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
    let historical: Historical
}
struct Views: Decodable {
    let total: Int
    let historical: Historical
}

struct Historical: Decodable {
    let values: [DateValueData]
}

struct DateValueData: Decodable {
    let date: String
    let value: Int
}
