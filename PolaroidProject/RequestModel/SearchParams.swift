//
//  UnsplashSearchParams.swift
//  PolaroidProject
//
//  Created by 박성민 on 7/25/24.
//

import Foundation

struct SearchParams {
    let query: String
    let page: String
    let per_page = "20"
    let orderby: Orderby
    let color: SearchColor?
}
