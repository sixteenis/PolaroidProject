//
//  UserModelManager.swift
//  PolaroidProject
//
//  Created by 박성민 on 7/22/24.
//

import UIKit

final class UserModelManager {
    static let shared = UserModelManager()
    
    @UserDefault(key: "userProfile", defaultValue: "profile_0", storage: .standard)
    var userProfile: String
    
    @UserDefault(key: "userNickname", defaultValue: "손님", storage: .standard)
    var userNickname: String
    
    @UserDefault(key: "userJoinDate", defaultValue: "언제죠?", storage: .standard)
    var userJoinDate: String
    
    private init() {}
    
    // MARK: - 랜덤 프로필 가져와주는 함수
    func getRandomProfile() -> String{
        ProfileImage.allCases.randomElement()?.image ?? ProfileImage.profile_0.image
    }
    func setUserJoinDate() {
        let date = Date()
        let myFormatter = DateFormatter()
        myFormatter.dateFormat = "yyyy.MM.dd 가입"
        let dateString = myFormatter.string(from: date)
        self.userJoinDate = dateString
    }
    
}
