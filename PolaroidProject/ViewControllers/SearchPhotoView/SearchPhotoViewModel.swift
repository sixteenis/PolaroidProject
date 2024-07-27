//
//  SearchPhotoViewModel.swift
//  PolaroidProject
//
//  Created by 박성민 on 7/24/24.
//

import Foundation

final class SearchPhotoViewModel {
    let networkManager = NetworkManager.shard
    var totalPage = 1
    var model: SearchParams!
    var likeRepository = LikeRepository.shard
    
    var inputViewDidLoad: Obsearvable<Void?> = Obsearvable(nil)
    var inputStartNetworking: Obsearvable<String> = Obsearvable("")
    var inputPage = Obsearvable(0)
    var inputLikeButton: Obsearvable<ImageDTO?> = Obsearvable(nil)
    
    var outputOrderby = Obsearvable(Orderby.latest)
    var outputSearchColor: Obsearvable<SearchColor?> = Obsearvable(nil)
    var outputLoadingSet = Obsearvable(true)
    
    var outputImageList = Obsearvable([ImageModel]())
    var outputLoadingset = Obsearvable(false)
    var outputButtonToggle = Obsearvable(false)
    //var outputPageCount = Obsearvable(0)
    
    init() {
        inputViewDidLoad.bind { _ in
            self.setUpView()
        }
        inputStartNetworking.bind { text in
            self.model = SearchParams(query: text, page: 1, orderby: self.outputOrderby.value, color: self.outputSearchColor.value)
            self.getImageList(self.model)
        }
        inputPage.bind { index in
            self.pagenation(index)
        }
        inputLikeButton.bind { data in
            guard let data else {return}
            self.changeLikeDate(data)
        }
    }
    
}

private extension SearchPhotoViewModel {
    func setUpView() {
        
    }
}
// MARK: - 통신 관련 부분
private extension SearchPhotoViewModel {
    func pagenation(_ index: Int) {
        if self.model.page < self.totalPage {
            self.model.page += 1
            self.getImageList(self.model)
        }
    }
    func getImageList(_ params: SearchParams) {
        let type = params
        self.outputLoadingset.value = false
        networkManager.requestSearch(type: type) { respon in
            self.outputLoadingset.value = true
            switch respon {
            case .success(let success):
                if params.page == 1{
                    self.outputImageList.value = success.Images
                    self.totalPage = success.total
                }else{
                    self.outputImageList.value.append(contentsOf: success.Images)
                }
            case .failure(let failure):
                print(failure)
            }
            
            
        }
    }
}

private extension SearchPhotoViewModel {
    func changeLikeDate(_ data: ImageDTO) {
        likeRepository.toggleLike(data) { bool in
            self.outputButtonToggle.value = bool
        }
            
        
    }
}
