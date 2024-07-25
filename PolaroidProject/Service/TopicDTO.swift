//
//  TopicModel.swift
//  PolaroidProject
//
//  Created by 박성민 on 7/25/24.
//

import Foundation

struct TopicDTO: Decodable {
    let id: String
    let created_at: String
    let width: Int
    let height: Int
    let urls: PhotoURLs
    let likes: Int
    let user: User
}

struct PhotoURLs: Decodable {
    let small: String
    let regular: String
    let raw: String
}

struct User: Decodable {
    let name: String
    let profile_image: UserProfile
}
struct UserProfile: Decodable {
    let medium: String
}
