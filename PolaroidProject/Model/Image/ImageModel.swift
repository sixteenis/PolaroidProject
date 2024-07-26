//
//  TopicModel.swift
//  PolaroidProject
//
//  Created by 박성민 on 7/26/24.
//

import Foundation

struct ImageModel: Hashable,Identifiable {
    let id = UUID()
    let data: ImageDTO
}
