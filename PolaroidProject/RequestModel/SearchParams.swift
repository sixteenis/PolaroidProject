//
//  UnsplashSearchParams.swift
//  PolaroidProject
//
//  Created by 박성민 on 7/25/24.
//

import Foundation

struct SearchParams: ParamsType {
    let query: String
    let page: Int
    let per_page = "20"
    let orderby: Orderby
    let color: SearchColor?
}
