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
    var likeList = LikeRepository.shard.getLikeLists()
    var ImageList = [ImageModel]()
    
    var inputViewDidLoad: Obsearvable<Void?> = Obsearvable(nil)
    var inputViewWillAppear: Obsearvable<Void?> = Obsearvable(nil)
    
    var inputStartNetworking: Obsearvable<String> = Obsearvable("")
    var inputPage = Obsearvable(0)
    var inputLikeButton: Obsearvable<ImageDTO?> = Obsearvable(nil)
    var inputFilterButtonTapped: Obsearvable<Void?> = Obsearvable(nil)
    
    var outputOrderby = Obsearvable(Orderby.latest)
    var outputSearchColor: Obsearvable<SearchColor?> = Obsearvable(nil)
    var outputLoadingSet = Obsearvable(true)
    
    var outputImageList = Obsearvable([ImageModel]())
    var outputSaveImageList = Obsearvable([ImageModel]())
    var outputLoadingset = Obsearvable(false)
    var outputButtonToggle = Obsearvable(false)
    
    var outputSetTitle: Obsearvable<String?> = Obsearvable(nil)
    var outputScrollingTop: Obsearvable<Void?> = Obsearvable(nil)
    var outputCellRefresh: Obsearvable<[String]?> = Obsearvable(nil)
    init() {
        inputViewDidLoad.bind { _ in
            self.setUpView("키워드를 검색해주세요!")
        }
        inputViewWillAppear.bind { _ in
            self.checkImageList()
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
        inputFilterButtonTapped.bind { _ in
            self.toggleFilterType()
            
        }
    }
    
}
// MARK: - 초기 세팅
private extension SearchPhotoViewModel {
    func setUpView(_ title: String) {
        self.outputSetTitle.value = title
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
                if success.Images.isEmpty {
                    self.setUpView("검색 결과가 없습니다!")
                }else{
                    if params.page == 1{
                        self.outputImageList.value = success.Images
                        self.ImageList = success.Images
                        self.totalPage = success.total
                        self.outputScrollingTop.value = ()
                    }else{
                        self.outputImageList.value.append(contentsOf: success.Images)
                        self.ImageList.append(contentsOf: success.Images)
                        
                    }
                }
            case .failure(let failure):
                self.setUpView(failure.rawValue)
            }
            
            
        }
    }
    func checkImageList() {
        
        //self.likeList = LikeRepository.shard.getLikeLists()
        //self.outputImageList.value = self.ImageList
        self.likeRepository.completion = {
            self.outputSaveImageList.value = self.ImageList
            print("되냐????????????")
        }
        
        
    }
    func toggleFilterType() {
        if self.outputOrderby.value == .latest {
            self.outputOrderby.value = .relevant
        }else{
            self.outputOrderby.value = .latest
        }
        if self.inputStartNetworking.value != "" {
            self.model.page = 1
            self.model.orderby = self.outputOrderby.value
            self.getImageList(self.model)
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
