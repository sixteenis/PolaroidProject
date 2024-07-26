//
//  TopicList.swift
//  PolaroidProject
//
//  Created by 박성민 on 7/25/24.
//

import Foundation


enum TopicSection: String,CaseIterable {
    case architecture = "architecture-interior"
    case golden = "golden-hour"
    case wallpapers = "wallpapers"
    case nature = "nature"
    case renders3D = "3d-renders"
    case travel = "travel"
    case textures = "textures-patterns"
    case street = "street-photography"
    case business = "business-wrok"
    var setionTitle: String {
        switch self {
        case .architecture:
            "건축 및 인테리어"
        case .golden:
            "골든 아워"
        case .wallpapers:
            "배경 화면"
        case .nature:
            "자연"
        case .renders3D:
            "3D 렌더링"
        case .travel:
            "여행"
        case .textures:
            "텍스쳐 및 패턴"
        case .street:
            "거리 사진"
        case .business:
            "비즈니스 및 업무"
        }
    }
    
}
