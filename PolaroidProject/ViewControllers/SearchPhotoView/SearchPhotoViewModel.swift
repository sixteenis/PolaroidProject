//
//  SearchPhotoViewModel.swift
//  PolaroidProject
//
//  Created by 박성민 on 7/24/24.
//

import Foundation
// TODO: 필터 색을 지정하고 디테일 뷰로 들가서 좋아요를 누른 경우 그 필터색을 적용해서 램에 저장하기 구현하자!, 하는 김에 컬러버튼 누르면 재통신하는 거도 구현하자!
final class SearchPhotoViewModel {
    private let networkManager = NetworkManager.shard
    private var likeRepository = LikeRepository.shard
    private var model: SearchParams = SearchParams(query: "", page: 1, orderby: .latest)
    private var likeList = LikeRepository.shard.getLikeLists()
    private var ImageList = [ImageModel]()
    private var colorList = [ColorModel]()
    private var totalPage = 1
    
    var inputViewDidLoad: Obsearvable<Void?> = Obsearvable(nil)
    var inputViewWillAppear: Obsearvable<Void?> = Obsearvable(nil)
    
    var inputStartNetworking: Obsearvable<String> = Obsearvable("")
    var inputPage = Obsearvable(0)
    var inputLikeButton: Obsearvable<ImageDTO?> = Obsearvable(nil)
    var inputFilterButtonTapped: Obsearvable<Void?> = Obsearvable(nil)
    var inputColorButtonTap: Obsearvable<ColorModel?> = Obsearvable(nil)
    
    private(set) var outputOrderby = Obsearvable(Orderby.relevant)
    private(set) var outputSearchColor: Obsearvable<SearchColor?> = Obsearvable(nil)
    private(set) var outputColors = Obsearvable([ColorModel]())
    private(set) var outputButtonToggle = Obsearvable(false)
    private(set) var outputLoadingSet = Obsearvable(true)
    
    private(set) var outputImageList = Obsearvable([ImageModel]())
    private(set) var outputSaveImageList = Obsearvable([ImageModel]())
    private(set) var outputSetTitle: Obsearvable<String?> = Obsearvable(nil)
    private(set) var outputScrollingTop: Obsearvable<Void?> = Obsearvable(nil)
    
    init() {
        inputViewDidLoad.bind { [weak self] _ in
            guard let self else { return }
            self.setUpView("키워드를 검색해 주세요!")
        }
        inputViewWillAppear.bind { [weak self] _ in
            guard let self else { return }
            self.checkImageList()
        }
        inputStartNetworking.bind { [weak self] text in
            guard let self else { return }
            self.model = SearchParams(query: text, page: 1, orderby: self.outputOrderby.value, color: self.outputSearchColor.value)
            self.getImageList(self.model)
        }
        inputPage.bind { [weak self] index in
            guard let self else { return }
            self.pagenation(index)
        }
        inputLikeButton.bind { [weak self] data in
            guard let self, let data else {return}
            self.changeLikeDate(data)
        }
        inputFilterButtonTapped.bind { [weak self] _ in
            guard let self else { return }
            self.toggleFilterType()
        }
        inputColorButtonTap.bind { [weak self] color in
            guard let self, let color else { return }
            self.upDateColor(color)
        }
    }
}
// MARK: - 초기 세팅
private extension SearchPhotoViewModel {
    func setUpView(_ title: String) {
        self.outputSetTitle.value = title
        self.outputColors.value = SearchColor.allCases.map { color in
            ColorModel(color: color)
        }
        self.colorList = self.outputColors.value
    }
    
}
// MARK: - 필터 컬러
// TODO: 컬러도 바뀔때마다 통신을 해줘야되는지 고민해보자!
private extension SearchPhotoViewModel {
    func upDateColor(_ type: ColorModel) {
        var result = [ColorModel]()
        for color in colorList {
            var tmp = color
            if color.color == type.color && color.isSelect {
                tmp.isSelect = false
            }
            else if color.color == type.color {
                tmp.isSelect = true
            }else{
                tmp.isSelect = false
            }
            result.append(tmp)
        }
        self.outputColors.value = result
        self.colorList = result
        self.model.page = 1
        if self.inputStartNetworking.value != "" {
            getImageList(self.model)
        }
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
        var type = params
        // MARK: - 일단 컬러는 통신할 때만 적용하는 걸로!
        type.color = self.colorList.filter {$0.isSelect == true}.first?.color
        self.outputLoadingSet.value = false
        networkManager.requestSearch(type: type) { [weak self] respon in
            guard let self else { return }
            self.outputLoadingSet.value = true
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
        self.likeRepository.completion = {
            self.outputSaveImageList.value = self.ImageList
            if self.outputSaveImageList.value.isEmpty {
                self.setUpView("키워드를 검색해 주세요!")
            }
        }
    }
    // 필터 버튼 토글 함수
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
// MARK: - 현재 선택된 컬러 담는 부분
private extension SearchPhotoViewModel {
    func changeLikeDate(_ data: ImageDTO) {
        let filterColor = self.colorList.filter { $0.isSelect == true}.first?.color
        likeRepository.toggleLike(data, color: filterColor) { bool in
            self.outputButtonToggle.value = bool
        }
    }
}
