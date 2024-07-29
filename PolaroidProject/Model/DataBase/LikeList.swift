//
//  LikeList.swift
//  PolaroidProject
//
//  Created by 박성민 on 7/26/24.
//

import Foundation
import RealmSwift

final class LikeList: Object {
    @Persisted(primaryKey: true) var imageId: String
    @Persisted var filterColor: Int?
    @Persisted var filterday: Date = Date()
    @Persisted var createdAt: String
    @Persisted var width: Int
    @Persisted var height: Int
    @Persisted var userName: String
    
    @Persisted var viewsTotal: Int
    @Persisted var downloadTotal: Int
    
    convenience init(imageId: String, filterColor: Int? = nil, createdAt: String, width: Int, height: Int, userName: String, viewsTotal: Int, downloadTotal: Int) {
        self.init()
        
        self.imageId = imageId
        self.filterColor = filterColor
        self.createdAt = createdAt
        self.width = width
        self.height = height
        self.userName = userName
        self.viewsTotal = viewsTotal
        self.downloadTotal = downloadTotal
    }
}

