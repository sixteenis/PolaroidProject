//
//  LoginViewModel.swift
//  PolaroidProject
//
//  Created by 박성민 on 7/22/24.
//

import Foundation


final class LoginViewModel {
    var settingType: Setting?
    //lazy var userbuilder = UserBuilder(settingType!)
    
    var inputViewDidLoade: Obsearvable<Void?> = Obsearvable(nil)
    var inputSetProfile: Obsearvable<String?> = Obsearvable(nil)
    lazy private(set) var outputProfileImage: Obsearvable<UserBuilder?> = Obsearvable(nil)
    init() {
        inputViewDidLoade.bind { [weak self] _ in
            guard let self, let settingType else { return }
            self.outputProfileImage.value = UserBuilder(settingType)
        }
        inputSetProfile.bind { [weak self] image in
            guard let self, let image else { return }
            self.setUpProfile(image)
        }
    }
    private func setUpProfile(_ image: String) {
        self.outputProfileImage.value?.profile = image
    }
    
    
}
