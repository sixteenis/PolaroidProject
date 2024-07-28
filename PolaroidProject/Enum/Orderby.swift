//
//  Orderby.swift
//  PolaroidProject
//
//  Created by 박성민 on 7/25/24.
//

import Foundation
enum Orderby: String {
    case latest = "latest"
    case relevant = "relevant"
    var title: String {
        switch self {
        case .latest:
            "최신순"
        case .relevant:
            "관련순"
        }
    }
}
