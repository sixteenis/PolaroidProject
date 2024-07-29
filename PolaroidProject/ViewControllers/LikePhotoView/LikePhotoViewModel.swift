//
//  LikePhotoViewModel.swift
//  PolaroidProject
//
//  Created by 박성민 on 7/24/24.
//

import Foundation

final class LikePhotoViewModel {
    let repository = LikeRepository.shard
    var colorList = [ColorModel]()
    
    var inputViewDidLoad: Obsearvable<Void?> = Obsearvable(nil)
    var inputViewWillAppear: Obsearvable<Void?> = Obsearvable(nil)
    var inputLikeButtonTap: Obsearvable<LikeList?> = Obsearvable(nil)
    var inputFilterButtonTapped: Obsearvable<Void?> = Obsearvable(nil)
    var inputColorButtonTap: Obsearvable<ColorModel?> = Obsearvable(nil)
    
    var outputGetLikeList = Obsearvable([LikeList]())
    var outputFilterType = Obsearvable(LikePhotoFilterType.latest)
    var outputScrollingTop: Obsearvable<Void?> = Obsearvable(nil)
    //private(set) var outputSearchColor: Obsearvable<SearchColor?> = Obsearvable(nil)
    private(set) var outputColors = Obsearvable([ColorModel]())
    init() {
        inputViewDidLoad.bind { _ in
            self.fetchLikeList()
            self.getColorList()
        }
        inputViewWillAppear.bind { _ in
            //if self.outputGetLikeList.value != self.repository.getLikeLists() {
                self.fetchLikeList()
            //}
        }
        inputLikeButtonTap.bind { item in
            guard let item else {return}
            self.repository.toggleLike(item)
            self.fetchLikeList()
        }
        inputFilterButtonTapped.bind { _ in
            self.toggleFilterType()
            
        }
        inputColorButtonTap.bind { color in
            guard let color else { return }
            self.upDateColor(color)
            //self.toggleFilterType()
        }
    }
}
private extension LikePhotoViewModel {
    func getColorList() {
        self.outputColors.value = SearchColor.allCases.map { color in
            ColorModel(color: color)
        }
        self.colorList = self.outputColors.value
    }
    func upDateColor(_ type: ColorModel) {
        var result = [ColorModel]()
        for i in colorList {
            var tmp = i
            if i.color == type.color && i.isSelect {
                tmp.isSelect = false
            }
            else if i.color == type.color {
                tmp.isSelect = true
            }else{
                tmp.isSelect = false
            }
            result.append(tmp)
        }
        self.outputColors.value = result
        self.colorList = result
        fetchLikeList()
    }
}
private extension LikePhotoViewModel {
    func fetchLikeList() {
        let type = self.outputFilterType.value
        let color = self.colorList.filter { $0.isSelect == true}.first?.color.colorIndex
        switch type {
        case .latest:
            self.outputGetLikeList.value = self.repository.getLikeLists().sorted(by: {$0.filterday > $1.filterday}).filter { $0.filterColor == color}
        case .past:
            self.outputGetLikeList.value = self.repository.getLikeLists().sorted(by: {$0.filterday < $1.filterday}).filter { $0.filterColor == color}
        }
        outputScrollingTop.value = ()
        //self.colorList = self.outputColors.value
    }
    func toggleFilterType() {
        if self.outputFilterType.value == .past {
            self.outputFilterType.value = .latest
        }else{
            self.outputFilterType.value = .past
        }
        
        fetchLikeList()
    }
    
}
