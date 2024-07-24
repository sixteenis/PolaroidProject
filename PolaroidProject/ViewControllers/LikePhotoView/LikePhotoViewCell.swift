//
//  LikePhotoViewCell.swift
//  PolaroidProject
//
//  Created by 박성민 on 7/24/24.
//

import UIKit

import SnapKit

final class LikePhotoViewCell:BaseCollectioViewCell {
    
    let testImage = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    override func setUpHierarchy() {
        contentView.addSubview(testImage)
    }
    override func setUpLayout() {
        testImage.snp.makeConstraints { make in
            make.edges.equalTo(contentView.safeAreaLayoutGuide)
        }
    }
    override func setUpView() {
        
    }
    func updateUI(_ i: Int) {
        testImage.image = UIImage(systemName: "star")
    }
}
