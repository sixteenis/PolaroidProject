//
//  DetailSettingModel.swift
//  PolaroidProject
//
//  Created by 박성민 on 7/28/24.
//

import Foundation



struct DetailSettingModel {
    let userName: String
    let date: String
    let size: String
    let hits: String
    let download: String
    
    var filterDate: String {
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withInternetDateTime]
        if let date = dateFormatter.date(from: self.date) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy년 M월 d일 게시됨"
            
            let formattedString = dateFormatter.string(from: date)
            return formattedString
        }
        return self.date
    }
}
