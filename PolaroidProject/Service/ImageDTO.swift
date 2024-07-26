//
//  TopicModel.swift
//  PolaroidProject
//
//  Created by 박성민 on 7/25/24.
//

import Foundation

struct ImageDTO: Decodable, Hashable {
    let imageId: String
    let createdAt: String
    let width: Int
    let height: Int
    let urls: PhotoURLs
    let likes: Int
    let user: User
    
    enum CodingKeys: String, CodingKey {
            case imageId = "id"
            case createdAt = "created_at"
            case width
            case height
            case urls
            case likes
            case user
        }
}

struct PhotoURLs: Decodable, Hashable {
    let small: String
    let regular: String
    let raw: String
}

struct User: Decodable, Hashable {
    let name: String
    let profileImage: UserProfile
    
    enum CodingKeys: String, CodingKey {
        case name
        case profileImage = "profile_image"
    }
}
struct UserProfile: Decodable, Hashable {
    let medium: String
}
