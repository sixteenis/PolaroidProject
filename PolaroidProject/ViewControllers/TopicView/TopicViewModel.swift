//
//  TopicViewModel.swift
//  PolaroidProject
//
//  Created by 박성민 on 7/24/24.
//

import Foundation

final class TopicViewModel {
    let networkMnager = NetworkManager.shard
    var inputViewDidLoad: Obsearvable<Void?> = Obsearvable(nil)
    
    var outputGetProfileImage: Obsearvable<String?> = Obsearvable(nil)
    var outputTopicList = Obsearvable([TopicModel]())
    
    init() {
        inputViewDidLoad.bind { _ in
            self.getProfileImage()
            self.getTopicData()
        }
    }
    
    
    
}
private extension TopicViewModel {
    func getProfileImage() {
        outputGetProfileImage.value = UserModelManager.shared.userProfile
    }
    func getTopicSection() -> [TopicSection]{
        let section = Array(TopicSection.allCases.shuffled().prefix(3))
        print(section)
        return section
    }
    
    func getTopicData() {
        let sections = getTopicSection()
        let group = DispatchGroup()
        var items = [TopicModel]()
        for section in sections {
            group.enter()
            let num = Int.random(in: 0...100)
            // TODO: 다른 주제여도 중복이 넘많다.. page를 설정해줘야됨.. 나중에 중복안되는 page 구현하기
            networkMnager.requestTopic(type: section,page: num) { respone in
                switch respone {
                case .success(let success):
                    items.append(success)
                case .failure(let failure):
                    print(failure)
                }
                group.leave()
            }
            
        }
        group.notify(queue: .main) {
            self.outputTopicList.value = items
        }
    }
    
    
    
}
