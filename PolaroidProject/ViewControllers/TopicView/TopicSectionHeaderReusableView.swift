//
//  TopicSectionHeaderReusableView.swift
//  PolaroidProject
//
//  Created by 박성민 on 7/24/24.
//

import UIKit
import SnapKit

final class TopicSectionHeaderReusableView: UICollectionReusableView {
    
    lazy var titleLabel: UILabel = {
        var label = UILabel()
        label.font = .heavy20
        label.textColor = .label
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .cWhite
        addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.leading.bottom.equalTo(self.safeAreaLayoutGuide)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
