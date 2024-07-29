//
//  LikePhotoFilterType.swift
//  PolaroidProject
//
//  Created by 박성민 on 7/28/24.
//

import Foundation

@frozen
enum LikePhotoFilterType: String,CaseIterable {
    case latest = "최신순"
    case past = "과거순"
}
