//
//  UserBuilder.swift
//  PolaroidProject
//
//  Created by 박성민 on 7/22/24.
//

import Foundation

class UserBuilder {
    var nickName: String
    var profile: String
    var mbti: [Bool?]
    
    private init(nickName: String, profile: String, mbti: [Bool?]) {
        self.nickName = nickName
        self.profile = profile
        self.mbti = mbti
    }
    convenience init(_ setType: Setting) {
        let user = UserModelManager.shared
        //guard let setType else { return }
        switch setType {
        case .onboarding:
            self.init(nickName: "", profile: user.getRandomProfile(), mbti: user.mbti)
        case .setting:
            self.init(nickName: user.userNickname, profile: user.userProfile, mbti: user.mbti)
        }
    }
}
