//
//  SearchDataType.swift
//  PolaroidProject
//
//  Created by 박성민 on 7/24/24.
//

import Foundation


enum SearchDataType: String, CaseIterable {
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

