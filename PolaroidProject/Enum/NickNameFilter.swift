//
//  NickNameFilter.swift
//  MeaningOutProject
//
//  Created by 박성민 on 6/14/24.
//

import UIKit

enum NickNameFilter: String, Error {
    case start = ""
    case lineNumber = "2글자 이상 10글자 미만으로 설정 해주세요."
    case specialcharacters = "닉네임에 @,#,$,% 는 포함할 수 없어요."
    case numbers = "닉네임에 숫자는 포함할 수 없어요."
    case spacer = "맨 앞뒤에는 엔터키를 포함할 수 없어요."
    case ok = "사용할 수 있는 닉네임이에요!"
    
    var color: UIColor {
        switch self {
        case .ok:
            return .cBlue
        default:
            return .cRed
        }
    }
}
