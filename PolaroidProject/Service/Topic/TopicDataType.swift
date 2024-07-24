//
//  TopicPhoto.swift
//  PolaroidProject
//
//  Created by 박성민 on 7/24/24.
//

import Foundation

enum TopicDataType: String, CaseIterable {
    case golden = "golden-hour"
    case business = "business-work"
    case architecture = "architecture-interior"
    
    private var baseURL: String {
        return APIKey.url
    }
    var requestURL: String {
        return baseURL + self.rawValue + "/photos?page=1&client_id=" + APIKey.key
    }
}


//골드 아워 -> golden-hour
//비즈니스 및 업무 -> business-work
//건축 및 인테리어 -> architecture-interior
//ex)    https://api.unsplash.com/topics/golden-hour/photos?page=1&client_id=gMqTUwFBz0rPblqBn_otnIzpClNZ1EO3kR-8Ptkhcxk
//       https://api.unsplash.com/topics/golden-hour/photos?page=1

