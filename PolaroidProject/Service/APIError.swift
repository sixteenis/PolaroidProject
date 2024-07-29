//
//  APIError.swift
//  PolaroidProject
//
//  Created by 박성민 on 7/25/24.
//

import Foundation

@frozen
enum APIError: String, Error {
    case badRequest400 = "필요한 입력값이 없어서 오류가 발생했습니다."
    case unauthorized401 = "잘못된 액세스 토큰입니다."
    case forbidden403 = "요청을 수행할 수 있는 권한이 없습니다."
    case notFound404 = "요청한 리소스가 없습니다."
}
