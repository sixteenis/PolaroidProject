//
//  LoginViewModel.swift
//  PolaroidProject
//
//  Created by 박성민 on 7/22/24.
//

import Foundation


final class LoginViewModel {
    var settingType: Setting?
    private lazy var builder = UserBuilder(self.settingType!)
    
    var inputViewDidLoade: Obsearvable<Void?> = Obsearvable(nil)
    var inputSetProfile: Obsearvable<String?> = Obsearvable(nil)
    var inputNickname: Obsearvable<String?> = Obsearvable(nil)
    var inputMBTIButton: Obsearvable<(Int,Int)?> = Obsearvable(nil)
    
    lazy private(set) var outputProfileImage: Obsearvable<String?> = Obsearvable(nil)
    private(set) var outputFilterTitle: Obsearvable<NickNameFilter> = Obsearvable(.start)
    private(set) var outputFilterBool = Obsearvable(false)
    private(set) var outputMBTICheck: Obsearvable<[Bool?]> = Obsearvable([Bool?]())
    
    init() {
        inputViewDidLoade.bind { [weak self] _ in
            guard let self, let settingType else { return }
            self.outputProfileImage.value = builder.profile
            self.outputMBTICheck.value = builder.mbti
        }
        inputSetProfile.bind { [weak self] image in
            guard let self, let image else { return }
            self.setUpProfile(image)
        }
        inputNickname.bind { name in
            self.nickNameFilter()
            self.checkName(name)
        }
        inputMBTIButton.bind { [weak self] index in
            guard let self, let index else { return }
            mbitSetting(index)
            
        }
    }
    
    private func mbitSetting(_ index: (Int,Int)) {
        var checkBool = index.1 == 1 ? true : false
        if outputMBTICheck.value[index.0] == checkBool {
            outputMBTICheck.value[index.0] = nil
        }else{
            outputMBTICheck.value[index.0] = checkBool
        }
    }
    private func setUpProfile(_ image: String) {
        self.outputProfileImage.value = image
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
