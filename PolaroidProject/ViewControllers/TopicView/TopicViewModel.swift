//
//  TopicViewModel.swift
//  PolaroidProject
//
//  Created by 박성민 on 7/24/24.
//

import Foundation

final class TopicViewModel {
    var inputViewDidLoad: Obsearvable<Void?> = Obsearvable(nil)
    
    var outputGetProfileImage: Obsearvable<String?> = Obsearvable(nil)
    init() {
        inputViewDidLoad.bind { _ in
            self.getProfileImage()
        }
    }
    
    private func getProfileImage() {
        outputGetProfileImage.value = UserModelManager.shared.userProfile
    }
}
