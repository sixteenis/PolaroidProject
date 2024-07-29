//
//  ColorModel.swift
//  PolaroidProject
//
//  Created by 박성민 on 7/29/24.
//

import Foundation


struct ColorModel: Hashable, Identifiable {
    let id = UUID()
    let color: SearchColor
    var isSelect = false
}
