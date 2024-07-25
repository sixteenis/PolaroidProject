//
//  TopicModel.swift
//  PolaroidProject
//
//  Created by 박성민 on 7/26/24.
//

import Foundation


struct TopicModel: Hashable {
    let id = UUID()
    let section: TopicSection
    let data: [TopicDTO]
}
