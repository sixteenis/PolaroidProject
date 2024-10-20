//
//  DetailViewModel.swift
//  PolaroidProject
//
//  Created by 박성민 on 7/24/24.
//

import Foundation

final class DetailViewModel {
    var bool: Bool? = nil
    // MARK: - 통신해야될 때
    var inputpushVC: Obsearvable<ImageDTO?> = Obsearvable(nil)
    // MARK: - 통신 없이 가능할 때
    var inputpushRelamVC: Obsearvable<LikeList?> = Obsearvable(nil)
    
    var inputLikeButton: Obsearvable<Void?> = Obsearvable(nil)
    var inputViewDidDisappear: Obsearvable<Void?> = Obsearvable(nil)
    
    private(set) var outputlikeBool: Obsearvable<Bool?> = Obsearvable(nil)
    private(set) var outputLikeItem: Obsearvable<LikeList?> = Obsearvable(nil)
    private(set) var outputSetModel: Obsearvable<DetailSettingModel?> = Obsearvable(nil)
    private(set) var outputImage: Obsearvable<String?> = Obsearvable(nil)
    private(set) var outputUserprofile: Obsearvable<String?> = Obsearvable(nil)
    private(set) var outputID: Obsearvable<(String?,String?)> = Obsearvable((nil,nil))
    private(set) var outputType:Obsearvable<DetailDataType?> = Obsearvable(nil)
    private(set) var outputAlert:Obsearvable<Void?> = Obsearvable(nil)
    private(set) var outputChartData: Obsearvable<ChartDatas?> = Obsearvable(nil)
    
    init() {
        inputpushVC.bind { [weak self] data in
            guard let self, let data else {return }
            self.outputlikeBool.value = false
            self.bool = false
            self.getSetModel(data)
            self.outputType.value = .network
        }
        inputpushRelamVC.bind { [weak self] likeList in
            guard let self, let likeList else {return}
            self.outputlikeBool.value = true
            self.bool = true
            self.outputID.value = (likeList.imageId, "\(likeList.imageId)\(likeList.createdAt)")
            self.getSetModel(likeList)
            self.outputType.value = .realm
        }
        inputLikeButton.bind { [weak self] _ in
            guard let self else { return }
            self.outputlikeBool.value?.toggle()
            self.outputAlert.value = ()
        }
        inputViewDidDisappear.bind(true) { [weak self] _ in
            guard let self else { return }
            self.checkData()
        }
    }
    static func dateFromString(_ dateString: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: dateString) ?? Date()
    }
    
}
// MARK: -통신해야될 때
private extension DetailViewModel {
    func getSetModel(_ dto: ImageDTO) {
        NetworkManager.shard.requestStatistics(id: dto.imageId) { [weak self] respons in
            guard let self else { return }
            switch respons {
            case .success(let success):
                let result = DetailSettingModel(userName: dto.user.name, date: dto.createdAt, size: "\(dto.height)  X \(dto.width)", hits: success.views.total.formatted(), download: success.downloads.total.formatted())
                self.outputSetModel.value = result
                self.outputChartData.value = ChartDatas(check: success.views.historical.values.map {ChartData(date: DetailViewModel.dateFromString($0.date), count: $0.value)}, Download: success.downloads.historical.values.map {ChartData(date: DetailViewModel.dateFromString($0.date), count: $0.value)})
            case .failure(_):
                let result = DetailSettingModel(userName: dto.user.name, date: dto.createdAt, size: "\(dto.height)  X \(dto.width)", hits: "0", download: "0")
                self.outputSetModel.value = result
            }
            self.outputImage.value = dto.urls.small
            self.outputUserprofile.value = dto.user.profileImage.medium
        }
    }
}
// MARK: - 통신 없이 가능할 때
private extension DetailViewModel {
    
    func getSetModel(_ likeList: LikeList) {
        let result = DetailSettingModel(userName: likeList.userName, date: likeList.createdAt, size: "\(likeList.height) X \(likeList.width)", hits: likeList.viewsTotal.formatted(), download: likeList.downloadTotal.formatted())
        self.outputSetModel.value = result
    }
}
// MARK: - 뷰가 없어지기 전 like 체크!
private extension DetailViewModel {
    func checkData() {
        guard let bool = outputlikeBool.value else {return}
        guard let beforBool = self.bool else {return }
        guard let type = self.outputType.value else {return}
        if bool != beforBool {
            switch type {
            case .realm:
                guard let item = self.inputpushRelamVC.value else {return}
                LikeRepository.shard.toggleLike(item)
            case .network:
                guard let item = self.inputpushVC.value else { return }
                LikeRepository.shard.saveLike(item)
            }
        }
    }
}
