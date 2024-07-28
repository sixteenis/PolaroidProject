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
    var inputFilterButtonTapped: Obsearvable<Void?> = Obsearvable(nil)
    
    var outputGetLikeList = Obsearvable([LikeList]())
    var outputFilterType = Obsearvable(LikePhotoFilterType.latest)
    var outputScrollingTop: Obsearvable<Void?> = Obsearvable(nil)
    init() {
        inputViewDidLoad.bind { _ in
            self.fetchLikeList(type: self.outputFilterType.value)
        }
        inputViewWillAppear.bind { _ in
            //if self.outputGetLikeList.value != self.repository.getLikeLists() {
                self.fetchLikeList(type: self.outputFilterType.value)
            //}
        }
        inputLikeButtonTap.bind { item in
            guard let item else {return}
            self.repository.toggleLike(item)
            self.fetchLikeList(type: self.outputFilterType.value)
        }
        inputFilterButtonTapped.bind { _ in
            self.toggleFilterType()
            
        }
    }
}

private extension LikePhotoViewModel {
    func fetchLikeList(type: LikePhotoFilterType) {
        switch type {
        case .latest:
            self.outputGetLikeList.value = self.repository.getLikeLists().sorted(by: {$0.filterday > $1.filterday})
        case .past:
            self.outputGetLikeList.value = self.repository.getLikeLists().sorted(by: {$0.filterday < $1.filterday})
        }
        
    }
    func toggleFilterType() {
        if self.outputFilterType.value == .past {
            self.outputFilterType.value = .latest
        }else{
            self.outputFilterType.value = .past
        }
        outputScrollingTop.value = ()
        fetchLikeList(type: self.outputFilterType.value)
    }
    
}
