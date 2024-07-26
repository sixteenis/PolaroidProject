//
//  LikeList.swift
//  PolaroidProject
//
//  Created by 박성민 on 7/26/24.
//

import Foundation
import RealmSwift

class LikeList: Object {
    @Persisted(primaryKey: true) var imageId: String
    @Persisted var createdAt: String
    @Persisted var width: Int
    @Persisted var height: Int
    @Persisted var userName: String
    @Persisted var userProfileImage: String
    convenience init(imageId: String, createdAt: String, width: Int, height: Int, userName: String, userProfileImage: String) {
        self.init()
        self.imageId = imageId
        self.createdAt = createdAt
        self.width = width
        self.height = height
        self.userName = userName
        self.userProfileImage = userProfileImage
    }
}
