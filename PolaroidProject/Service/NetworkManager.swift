//
//  UnsplashNetworkManager.swift
//  PolaroidProject
//
//  Created by 박성민 on 7/25/24.
//

import Foundation

import Alamofire

final class NetworkManager {
    static let shard = NetworkManager()
    private init() {}
    
    func requestTopic(type: TopicSection) {
        do {
            let request = try UnsplashRouter.topic(params: type).asURLRequest()

            AF.request(request)
                .responseDecodable(of: [TopicDTO].self ) { response in
                    switch response.result {
                    case .success(let data):
                        print(data)
                    case .failure(let error):
                        print(error)
                    }
                }
        }catch {
            print("에러 발생!")
        }
    }
    func requestSearch(type: SearchParams) {
        do {
            let request = try UnsplashRouter.search(params: type).asURLRequest()

            AF.request(request)
                .responseDecodable(of: SearchDTO.self ) { response in
                    switch response.result {
                    case .success(let data):
                        dump(data)
                    case .failure(let error):
                        print(error)
                    }
                }
        }catch {
            print("에러 발생!")
        }
    }
}
