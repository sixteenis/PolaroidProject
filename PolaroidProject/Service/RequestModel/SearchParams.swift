//
//  UnsplashSearchParams.swift
//  PolaroidProject
//
//  Created by 박성민 on 7/25/24.
//

import Foundation

struct SearchParams {
    let query: String
    var page: Int
    let per_page = "20"
    var orderby: Orderby
    var color: SearchColor?
}
