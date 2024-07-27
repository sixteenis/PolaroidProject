//
//  DetailViewModel.swift
//  PolaroidProject
//
//  Created by 박성민 on 7/24/24.
//

import Foundation
import UIKit

class DetailViewModel {
    // MARK: - 통신해야될 때
    var inputpushVC: Obsearvable<ImageDTO?> = Obsearvable(nil)
    
    
    // MARK: - 통신 없이 가능할 때
    var inputpushRelamVC: Obsearvable<LikeList?> = Obsearvable(nil)
    
    
    
    var outputlikeBool: Obsearvable<Bool?> = Obsearvable(nil)
    var outputLikeItem: Obsearvable<LikeList?> = Obsearvable(nil)
    
    var outputImage: Obsearvable<UIImage?> = Obsearvable(nil)
    var outputUserprofile: Obsearvable<UIImage?> = Obsearvable(nil)
    var outputSetModel: Obsearvable<DetailSettingModel?> = Obsearvable(nil)
    
    init() {
        inputpushVC.bind { data in
            guard let data else {return }
            self.outputlikeBool.value = false
            self.getSetModel(data)
        }
        inputpushRelamVC.bind { likeList in
            self.outputlikeBool.value = true
        }
        
    }
    
}
// MARK: -통신해야될 때
private extension DetailViewModel {
    func getSetModel(_ dto: ImageDTO) {
        NetworkManager.shard.requestStatistics(id: dto.imageId) { respons in
            switch respons {
            case .success(let success):
                let result = DetailSettingModel(userName: dto.user.name, date: dto.createdAt, size: "\(dto.height)  X \(dto.width)", hits: success.views.total.formatted(), download: success.downloads.total.formatted())
                self.outputSetModel.value = result
            case .failure(let failure):
                let result = DetailSettingModel(userName: dto.user.name, date: dto.createdAt, size: "\(dto.height)  X \(dto.width)", hits: "0", download: "0")
                self.outputSetModel.value = result
            }
        }
        
    }
}
// MARK: - 통신 없이 가능할 때
private extension DetailViewModel {
    func getLikeList(_ id: String) {
        let result = LikeRepository.shard.getLikeList(id)
        self.outputLikeItem.value = result
    }
}

private extension DetailViewModel {
    
}
