//
//  LikePhotoViewModel.swift
//  PolaroidProject
//
//  Created by 박성민 on 7/24/24.
//

import Foundation


final class LikePhotoViewModel {
    private let repository = LikeRepository.shard
    private var colorList = [ColorModel]()
    
    var inputViewDidLoad: Obsearvable<Void?> = Obsearvable(nil)
    var inputViewWillAppear: Obsearvable<Void?> = Obsearvable(nil)
    
    var inputLikeButtonTap: Obsearvable<LikeList?> = Obsearvable(nil)
    var inputColorButtonTap: Obsearvable<ColorModel?> = Obsearvable(nil)
    var inputFilterButtonTapped: Obsearvable<Void?> = Obsearvable(nil)

    private(set) var outputGetLikeList = Obsearvable([LikeList]())
    private(set) var outputFilterType = Obsearvable(LikePhotoFilterType.latest)
    private(set) var outputScrollingTop: Obsearvable<Void?> = Obsearvable(nil)
    private(set) var outputColors = Obsearvable([ColorModel]())
    
    init() {
        inputViewDidLoad.bind { [weak self] _ in
            guard let self else { return }
            self.fetchLikeList()
            self.getColorList()
        }
        inputViewWillAppear.bind { [weak self] _ in
            guard let self else { return }
            self.fetchLikeList(isScroll: true)
        }
        
        inputFilterButtonTapped.bind { [weak self] _ in
            guard let self else { return }
            self.toggleFilterType()
            
        }
        inputColorButtonTap.bind { [weak self] color in
            guard let self, let color else { return }
            self.upDateColor(color)
        }
        inputLikeButtonTap.bind { [weak self] item in
            guard let self, let item else {return}
            self.repository.toggleLike(item)
            self.fetchLikeList(isScroll: false)
        }
    }
}

// MARK: - 컬러, 필터 최종 결과 함수
private extension LikePhotoViewModel {
    func fetchLikeList(isScroll: Bool = false) {
        let type = self.outputFilterType.value
        let color = self.colorList.filter { $0.isSelect == true}.first?.color.colorIndex
        var filter = [LikeList]()
        
        switch type {
        case .latest:
            filter = self.repository.getLikeLists().sorted(by: {$0.filterday > $1.filterday})
        case .past:
            filter = self.repository.getLikeLists().sorted(by: {$0.filterday < $1.filterday})
        }
        if color != nil {
            filter = filter.filter { $0.filterColor == color}
        }
        
        self.outputGetLikeList.value = filter
        if isScroll {
            outputScrollingTop.value = ()
        }
    }
}
// MARK: - 컬러 부분
private extension LikePhotoViewModel {
    func getColorList() {
        self.outputColors.value = SearchColor.allCases.map { color in
            ColorModel(color: color)
        }
        self.colorList = self.outputColors.value
    }
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
        fetchLikeList(isScroll: true)
    }
}
// MARK: - 필터 버튼 부분
private extension LikePhotoViewModel {
    func toggleFilterType() {
        if self.outputFilterType.value == .past {
            self.outputFilterType.value = .latest
        }else{
            self.outputFilterType.value = .past
        }
        fetchLikeList(isScroll: true)
    }
}
