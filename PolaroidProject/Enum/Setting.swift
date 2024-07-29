//
//  Setting.swift
//  PolaroidProject
//
//  Created by 박성민 on 7/22/24.
//

import Foundation

@frozen
enum Setting: Equatable {
    case onboarding
    case setting
    
    var navTitle: String {
        switch self {
        case .onboarding:
            return "PROFILE SETTING"
        case .setting:
            return "EDIT PROFILE"
        }
    }
}
