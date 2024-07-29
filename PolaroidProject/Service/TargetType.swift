//
//  TargetType.swift
//  SeSAC5LSLPPractice
//
//  Created by 박성민 on 7/25/24.
//

import Foundation
import Alamofire
// url, header, paramater, boy, query
protocol TargetType: URLRequestConvertible {
    var baseURL: String { get }
    var method: HTTPMethod { get }
    var path: String { get }
    var header: [String: String] { get }
    var parameters: [String:Any]? { get }
    var queryItmes: [URLQueryItem]? { get }
    var body: Data? { get }
}

extension TargetType {
    func asURLRequest() throws -> URLRequest {
        var url = try baseURL.asURL()
        url.appendPathComponent(path)
        if let parameters = parameters {
            var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
            urlComponents?.queryItems = parameters.map { (key, value) in
                URLQueryItem(name: key, value: "\(value)")
            }
            url = urlComponents?.url ?? url
        }
        var request = URLRequest(url: url)
        request.method = method
        request.allHTTPHeaderFields = header
        request.httpBody = body
        return request
    }
}
