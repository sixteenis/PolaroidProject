//
//  ChartData.swift
//  PolaroidProject
//
//  Created by 박성민 on 10/20/24.
//

import Foundation
struct ChartDatas {
    let check: [ChartData]
    let Download: [ChartData]
}
struct ChartData: Identifiable {
    let id = UUID()
    let date: Date
    let count: Int
}
