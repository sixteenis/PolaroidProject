//
//  SearchPhotoViewModel.swift
//  PolaroidProject
//
//  Created by 박성민 on 7/24/24.
//

import Foundation

final class SearchPhotoViewModel {
    //let model = SearchParams(query: "", page: 1, orderby: .latest, color: <#T##SearchColor?#>)
    let networkManager = NetworkManager.shard
    
    var inputViewDidLoad: Obsearvable<Void?> = Obsearvable(nil)
    var inputStartNetworking: Obsearvable<String> = Obsearvable("")
    
    var outputOrderby = Obsearvable(Orderby.latest)
    var outputSearchColor: Obsearvable<SearchColor?> = Obsearvable(nil)
    
    var outputImageList = Obsearvable([ImageDTO]())
    var outputLoadingset = Obsearvable(false)
    var outputPageCount = Obsearvable(0)
    
    init() {
        
        inputViewDidLoad.bind { _ in
            self.setUpView()
        }
        inputStartNetworking.bind { text in
            self.getImageList(text)
        }
    }
    
}

private extension SearchPhotoViewModel {
    func setUpView() {
        
    }
}
// MARK: - 통신 관련 부분
private extension SearchPhotoViewModel {
    func getImageList(_ text: String) {
        let type = SearchParams(query: text, page: 1, orderby: self.outputOrderby.value, color: self.outputSearchColor.value)
        networkManager.requestSearch(type: type) { respon in
            switch respon {
            case .success(let success):
                self.outputImageList.value = success.results
                self.outputPageCount.value = success.total_pages
            case .failure(let failure):
                print(failure)
            }
            
        }
    }
}
