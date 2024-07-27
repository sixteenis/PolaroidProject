//
//  LikeList.swift
//  PolaroidProject
//
//  Created by 박성민 on 7/26/24.
//

import Foundation
import RealmSwift

class LikeList: Object {
    @Persisted(primaryKey: true) var imageId: String
    @Persisted var filterColor: Int?
    @Persisted var filterday: Int?
    @Persisted var createdAt: String
    @Persisted var width: Int
    @Persisted var height: Int
    @Persisted var userName: String
    
    @Persisted var viewsTotal: Int
    @Persisted var downloadTotal: Int
    
    convenience init(imageId: String, filterColor: Int? = nil, filterday: Int? = nil, createdAt: String, width: Int, height: Int, userName: String, viewsTotal: Int, downloadTotal: Int) {
        self.init()
        self.imageId = imageId
        self.filterColor = filterColor
        self.filterday = filterday
        self.createdAt = createdAt
        self.width = width
        self.height = height
        self.userName = userName

        self.viewsTotal = viewsTotal
        self.downloadTotal = downloadTotal
    }
}

//detailvie로 갈때 likelist 체크! 값이없다? 그럼 통신해서 값을 likelist에 넣고 id만 전달해서 view 실행
//likelist에 값이 있다? 그럼 그냥 id만 넣어서 줘!
//좋아요 기능을 누르면 likeList에 통계 통신해서 넣어서 줘!
