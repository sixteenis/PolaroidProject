//
//  BaseCollectioViewCell.swift
//  MeaningOutProject
//
//  Created by 박성민 on 7/10/24.
//

import UIKit

class BaseCollectioViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpHierarchy()
        setUpLayout()
        setUpView()
    }
    
    func setUpHierarchy() {}
    
    func setUpLayout() {}
    
    func setUpView() {}
    
    // 모든 iOS버전에서 사용하지 않겠다
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
