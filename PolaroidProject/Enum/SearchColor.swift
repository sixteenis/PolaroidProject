//
//  SearchColor.swift
//  PolaroidProject
//
//  Created by 박성민 on 7/25/24.
//

import UIKit

@frozen
enum SearchColor: String, CaseIterable {
    case black = "black"
    case white = "white"
    case yellow = "yellow"
    case red = "red"
    case purple = "purple"
    case green = "green"
    case blue = "blue"

    var descritpion: String {
        switch self {
        case .black:
            "블랙"
        case .white:
            "화이트"
        case .yellow:
            "옐로우"
        case .red:
            "레드"
        case .purple:
            "퍼플"
        case .green:
            "그린"
        case .blue:
            "블루"
        }
    }
    var colorSet: UIColor {
        switch self {
        case .black:
                .cBlack
        case .white:
                .cWhite
        case .yellow:
                .systemYellow
        case .red:
                .systemRed
        case .purple:
                .purple
        case .green:
                .systemGreen
        case .blue:
                .cBlue
        }
    }
    var colorIndex: Int {
        switch self {
        case .black:
            0
        case .white:
            1
        case .yellow:
            2
        case .red:
            3
        case .purple:
            4
        case .green:
            5
        case .blue:
            6
        }
    }
}
