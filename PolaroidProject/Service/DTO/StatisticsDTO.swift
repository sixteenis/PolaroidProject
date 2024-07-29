//
//  StatisticsDTO.swift
//  PolaroidProject
//
//  Created by 박성민 on 7/27/24.
//

import Foundation

struct StatisticsDTO: Decodable{
    let downloads: Downloads
    let views: Views
}
struct Downloads: Decodable {
    let total: Int
}
struct Views: Decodable {
    let total: Int
}
