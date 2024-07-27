//
//  DetailViewModel.swift
//  PolaroidProject
//
//  Created by 박성민 on 7/24/24.
//

import Foundation

class DetailViewModel {
    // MARK: - 통신해야될 때
    var inputpushVC: Obsearvable<ImageDTO?> = Obsearvable(nil)
    
    
    // MARK: - 통신 없이 가능할 때
    var inputpushRelamVC: Obsearvable<LikeList?> = Obsearvable(nil)
    
    
    
    var outputlikeBool: Obsearvable<Bool?> = Obsearvable(nil)
    var outputLikeItem: Obsearvable<LikeList?> = Obsearvable(nil)
    
    var outputSetModel: Obsearvable<DetailSettingModel?> = Obsearvable(nil)
    var outputImage: Obsearvable<String?> = Obsearvable(nil)
    var outputUserprofile: Obsearvable<String?> = Obsearvable(nil)
    var outputID: Obsearvable<(String?,String?)> = Obsearvable((nil,nil))
    
    init() {
        inputpushVC.bind { data in
            guard let data else {return }
            self.outputlikeBool.value = false
            self.getSetModel(data)
        }
        inputpushRelamVC.bind { likeList in
            guard let likeList else {return}
            self.outputlikeBool.value = true
            self.outputID.value = (likeList.imageId, "\(likeList.imageId)\(likeList.createdAt)")
            self.getSetModel(likeList)
        }
        
    }
    
}
// MARK: -통신해야될 때
private extension DetailViewModel {
    func getSetModel(_ dto: ImageDTO) {
        //dto.user.profileImage.medium
        NetworkManager.shard.requestStatistics(id: dto.imageId) { respons in
            switch respons {
            case .success(let success):
                let result = DetailSettingModel(userName: dto.user.name, date: dto.createdAt, size: "\(dto.height)  X \(dto.width)", hits: success.views.total.formatted(), download: success.downloads.total.formatted())
                self.outputSetModel.value = result
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

private extension DetailViewModel {
    
}
