//
//  UserBuilder.swift
//  PolaroidProject
//
//  Created by 박성민 on 7/22/24.
//

import Foundation

struct UserBuilder {
    var nickName: String
    var profile: String
    var mbti: [Bool?]
    
    private init(nickName: String, profile: String, mbti: [Bool?]) {
        self.nickName = nickName
        self.profile = profile
        self.mbti = mbti
    }
    init() {
        let user = UserModelManager.shared
        self.init(nickName: user.userNickname, profile: user.userProfile, mbti: user.mbti)
    }
}
