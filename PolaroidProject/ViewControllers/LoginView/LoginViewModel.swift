//
//  LoginViewModel.swift
//  PolaroidProject
//
//  Created by 박성민 on 7/22/24.
//

import Foundation


final class LoginViewModel {
    
    var settingType: Setting?
    private var builder = UserBuilder()
    private let user = UserModelManager.shared
    
    var inputViewDidLoade: Obsearvable<Void?> = Obsearvable(nil)
    var inputSetProfile: Obsearvable<String?> = Obsearvable(nil)
    var inputNickname: Obsearvable<String?> = Obsearvable(nil)
    var inputMBTIButton: Obsearvable<(Int,Int)?> = Obsearvable(nil)
    var inputSaveUserData: Obsearvable<String> = Obsearvable("")
    
    private(set) var outputProfileImage: Obsearvable<String?> = Obsearvable(nil)
    private(set) var outputFilterTitle: Obsearvable<NickNameFilter> = Obsearvable(.start)
    private(set) var outputFilterBool = Obsearvable(false)
    private(set) var outputMBTICheck: Obsearvable<[Bool?]> = Obsearvable([Bool?]())
    // MARK: - 하나의 빌더로 output을 줄일 수 있을거 같긴한데 흠??
    //lazy private(set) var outputUser: Obsearvable<UserBuilder?> = Obsearvable(nil)
    
    init() {
        inputViewDidLoade.bind { [weak self] _ in
            guard let self else { return }
            self.outputProfileImage.value = builder.profile
            self.outputMBTICheck.value = builder.mbti
        }
        inputSetProfile.bind { [weak self] image in
            guard let self, let image else { return }
            self.setUpProfile(image)
        }
        inputNickname.bind { [weak self] name in
            guard let self else  { return }
            self.nickNameFilter(name!)
            self.checkCanStart()
        }
        inputMBTIButton.bind { [weak self] index in
            guard let self, let index else { return }
            self.mbitSetting(index)
            self.checkCanStart()
        }
        inputSaveUserData.bind { [weak self] name in
            guard let self else  { return }
            self.saveUserData(name)
        }
    }
    
    private func mbitSetting(_ index: (Int,Int)) {
        let checkBool = index.1 == 1 ? true : false
        if outputMBTICheck.value[index.0] == checkBool {
            outputMBTICheck.value[index.0] = nil
        }else{
            outputMBTICheck.value[index.0] = checkBool
        }
        
    }
    private func setUpProfile(_ image: String) {
        self.outputProfileImage.value = image
    }
    
    private func checkCanStart() {
        
        if self.outputFilterTitle.value == .ok && !self.outputMBTICheck.value.contains(nil){
            outputFilterBool.value = true
            return
        }
        outputFilterBool.value = false
    }
    
    
    private func nickNameFilter(_ name: String) {
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
    
    private func saveUserData(_ name: String) {
        if self.settingType == .onboarding {
            user.setUserJoinDate()
        }
        user.userNickname = name
        user.userProfile = self.outputProfileImage.value!
        user.mbti = self.outputMBTICheck.value
    }
    
}
