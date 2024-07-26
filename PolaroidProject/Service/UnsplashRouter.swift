//
//  UnsplashRouter.swift
//  PolaroidProject
//
//  Created by 박성민 on 7/25/24.
//

import Foundation

import Alamofire

enum UnsplashRouter: URLRequestConvertible {
    case topic(params: TopicSection, page: Int)
    case search(params: SearchParams)
}

extension UnsplashRouter: TargetType {
    var parameters: [String : Any]? {
        switch self {
        case .topic(let params, let page):
            let result = [
                "topics": params.rawValue,
                "page": "\(page)",
                "client_id": APIKey.key
            ]
            return result
        case .search(let params):
            var result = [
                "query": params.query,
                "page": "\(params.page)",
                "per_page": params.per_page,
                "order_by": params.orderby.rawValue,
                "client_id": APIKey.key
            ]
            if let color = params.color {
                result["color"] = color.rawValue
            }
            return result
        }
    }
    
    var baseURL: String {
        switch self {
        case .topic:
            return APIKey.url
        case .search:
            return APIKey.url
        }
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .topic:
            return .get
        case .search:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .topic:
            return  "photos"
        case .search:
            return "search/photos"
        }
    }

    var header: [String : String] {
        return ["Content-Type" : "application/json"]
    }
    
    var queryItmes: [URLQueryItem]? {
        return nil
    }
    
    var body: Data? {
        return nil
    }
    
    
}
