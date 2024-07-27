//
//  LikePhotoViewModel.swift
//  PolaroidProject
//
//  Created by 박성민 on 7/24/24.
//

import Foundation

final class LikePhotoViewModel {
    let repository = LikeRepository.shard
    var inputViewDidLoad: Obsearvable<Void?> = Obsearvable(nil)
    var inputViewWillAppear: Obsearvable<Void?> = Obsearvable(nil)
    var inputLikeButtonTap: Obsearvable<LikeList?> = Obsearvable(nil)
    
    
    var outputGetLikeList = Obsearvable([LikeList]())
    init() {
        inputViewDidLoad.bind { _ in
            self.fetchLikeList()
        }
        inputViewWillAppear.bind { _ in
            if self.outputGetLikeList.value != self.repository.getLikeList() {
                self.fetchLikeList()
            }
        }
        inputLikeButtonTap.bind { item in
            guard let item else {return}
            self.repository.toggleLike(item)
            self.fetchLikeList()
        }
    }
}

private extension LikePhotoViewModel {
    func fetchLikeList() {
        self.outputGetLikeList.value = self.repository.getLikeList()
    }
}
