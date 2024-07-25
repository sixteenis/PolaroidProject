//
//  UnsplashNetworkManager.swift
//  PolaroidProject
//
//  Created by 박성민 on 7/25/24.
//

import Foundation

import Alamofire

final class UnsplashNetworkManager {
    static let shard = UnsplashNetworkManager()
    private init() {}
    
    func requestTopic(type: TopicSection) {
        do {
            let request = try UnsplashRouter.topic(params: type).asURLRequest()
            print(request)
            AF.request(request)
                .responseString { com in
                    switch com.result {
                    case .success(let datas):
                        print(datas)
                    case .failure(let err):
                        print(err)
                    }
                }
//                .responseDecodable(of: ) { response in
//                    switch response.result {
//                    }
//                }
        }catch {
            print("에러 발생!")
        }
    }
    func requestSearch(type: SearchParams) {
        do {
            let request = try UnsplashRouter.search(params: type).asURLRequest()
            AF.request(request)
                .responseString { com in
                    switch com.result {
                    case .success(let datas):
                        print(datas)
                    case .failure(let err):
                        print(err)
                    }
                }
        } catch {
          print("에러 발생!")
        }
    }
}
