//
//  SearchDTO.swift
//  PolaroidProject
//
//  Created by 박성민 on 7/25/24.
//

import Foundation

struct SearchDTO: Decodable, Hashable {
    let total: Int
    let total_pages: Int
    let results: [TopicDTO]
}
