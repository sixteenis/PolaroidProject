//
//  LoginViewModel.swift
//  PolaroidProject
//
//  Created by 박성민 on 7/22/24.
//

import Foundation


final class LoginViewModel {
    var settingType: Setting?
    
    var inputViewDidLoade: Obsearvable<Void?> = Obsearvable(nil)
    var inputSetProfile: Obsearvable<String?> = Obsearvable(nil)
    var inputNickname: Obsearvable<String?> = Obsearvable(nil)
    
    lazy private(set) var outputProfileImage: Obsearvable<UserBuilder?> = Obsearvable(nil)
    private(set) var outputFilterTitle: Obsearvable<NickNameFilter> = Obsearvable(.start)
    private(set) var outputFilterBool = Obsearvable(false)
    
    init() {
        inputViewDidLoade.bind { [weak self] _ in
            guard let self, let settingType else { return }
            self.outputProfileImage.value = UserBuilder(settingType)
        }
        inputSetProfile.bind { [weak self] image in
            guard let self, let image else { return }
            self.setUpProfile(image)
        }
        inputNickname.bind { name in
            self.nickNameFilter()
            self.checkName(name)
        }
    }
    
    private func setUpProfile(_ image: String) {
        self.outputProfileImage.value?.profile = image
    }
    private func checkName(_ name: String?) {
        if self.outputFilterTitle.value == .ok {
            guard name != nil else {return}
            outputFilterBool.value = true
            return
        }
        outputFilterBool.value = false
    }
    private func nickNameFilter() {
        guard let name = self.inputNickname.value else { return }
        let specialChar = CharacterSet(charactersIn: "@#$%")
        let filterNum = name.filter{$0.isNumber}
        if name.count < 2 || name.count >= 10 {
            outputFilterTitle.value = .lineNumber
            return
        }
        if name.rangeOfCharacter(from: specialChar) != nil {
            outputFilterTitle.value = .specialcharacters
            return
        }
        if name.isEmpty {
            outputFilterTitle.value = .numbers
            return
        }
        if !filterNum.isEmpty {
            outputFilterTitle.value = .numbers
            return
        }
        if name.hasPrefix(" ") || name.hasSuffix(" ") {
            outputFilterTitle.value = .spacer
            return
        }
        outputFilterTitle.value = .ok
    }
    
}
