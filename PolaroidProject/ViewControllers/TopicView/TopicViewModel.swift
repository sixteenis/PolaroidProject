//
//  TopicViewModel.swift
//  PolaroidProject
//
//  Created by 박성민 on 7/24/24.
//

import Foundation

final class TopicViewModel {
    private let networkManager = NetworkManager.shard
    
    var inputViewDidLoad: Obsearvable<Void?> = Obsearvable(nil)
    var inputCheckProfile: Obsearvable<Void?> = Obsearvable(nil)
    
    private(set) var outputGetProfileImage: Obsearvable<String?> = Obsearvable(nil)
    private(set) var outputTopicList = Obsearvable([TopicSeciontModel]())
    private(set) var outputLoadingSet = Obsearvable(false)
    private(set) var outputErrorTitle: Obsearvable<String> = Obsearvable("")

    init() {
        inputViewDidLoad.bind { [weak self] _ in
            guard let self else { return }
            self.getProfileImage()
            self.getTopicData()
        }
        inputCheckProfile.bind { [weak self] _ in
            guard let self else { return }
            self.checkProfileImage()
        }
    }
}
// MARK: - 프로필 관련
private extension TopicViewModel {
    func getProfileImage() {
        outputGetProfileImage.value = UserModelManager.shared.userProfile
    }
    func checkProfileImage() {
        guard let profile = outputGetProfileImage.value else {return}
        if UserModelManager.shared.userProfile != profile {
            outputGetProfileImage.value = UserModelManager.shared.userProfile
        }
    }
}
// MARK: - collectionView 관련
private extension TopicViewModel {
    func getTopicSection() -> [TopicSection]{
        let section = Array(TopicSection.allCases.shuffled().prefix(3))
        return section
    }
    //통신 부분
    func getTopicData() {
        let sections = getTopicSection()
        let group = DispatchGroup()
        var items = [TopicSeciontModel]()
        outputLoadingSet.value = false
        for section in sections {
            group.enter()
            let num = Int.random(in: 0...1000)
            networkManager.requestTopic(type: section,page: num) { [weak self] respone in
                guard let self else { return }
                switch respone {
                case .success(let success):
                    items.append(success)
                case .failure(let failure):
                    self.outputErrorTitle.value = failure.rawValue
                }
                group.leave()
            }
        }
        group.notify(queue: .main) {
            self.outputLoadingSet.value = true
            self.outputTopicList.value = items
        }
    }
}
