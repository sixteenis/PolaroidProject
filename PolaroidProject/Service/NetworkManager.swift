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
    
    func requestTopic(type: TopicSection,page: Int, completion: @escaping (Result<TopicSeciontModel,APIError>) -> Void) {
        do {
            let request = try UnsplashRouter.topic(params: type, page: page).asURLRequest()

            AF.request(request)
                .responseDecodable(of: [ImageDTO].self ) { response in
                    switch response.result {
                    case .success(let data):
                        let result = data.map {TopicModel(data: $0)}
                        let results = TopicSeciontModel(section: type, topicList: result)
                        completion(.success(results))
                    case .failure(let error):
                        print(error)
                        switch response.response?.statusCode {
                        case 400:
                            completion(.failure(.badRequest400))
                        case 401:
                            completion(.failure(.unauthorized401))
                        case 403:
                            completion(.failure(.forbidden403))
                        case 404:
                            completion(.failure(.notFound404))
                        default:
                            print("알 수 없는 오류 발생")
                        }
                    }
                }
        }catch {
            print("에러 발생!")
        }
    }
    
    func requestSearch(type: SearchParams, completion: @escaping (Result<SearchDTO, APIError>) -> Void) {
        do {
            let request = try UnsplashRouter.search(params: type).asURLRequest()

            AF.request(request)
                .responseDecodable(of: SearchDTO.self ) { response in
                    switch response.result {
                    case .success(let data):
                        completion(.success(data))
                    case .failure(let error):
                        print(error)
                        switch response.response?.statusCode {
                        case 400:
                            completion(.failure(.badRequest400))
                        case 401:
                            completion(.failure(.unauthorized401))
                        case 403:
                            completion(.failure(.forbidden403))
                        case 404:
                            completion(.failure(.notFound404))
                        default:
                            print("알 수 없는 오류 발생")
                        }
                    }
                }
        }catch {
            print("에러 발생!")
        }
    }
}
