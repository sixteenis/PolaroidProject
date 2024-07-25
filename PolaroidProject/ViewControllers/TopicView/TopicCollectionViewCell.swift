//
//  TopicCollectionViewCell.swift
//  PolaroidProject
//
//  Created by 박성민 on 7/24/24.
//

import UIKit
import SnapKit
import Then
class TopicCollectionViewCell: BaseCollectioViewCell {
    let profileImage = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 15
    }
    let blackImage = UIView().then {
        $0.backgroundColor = .cKhaki
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 15
    }
    let star = UIImageView().then {
        $0.image = UIImage(systemName: "star.fill")
        $0.contentMode = .scaleAspectFit
        $0.tintColor = .systemYellow
    }
    let likesCount = UILabel().then {
        $0.textColor = .cWhite
        $0.numberOfLines = 1
        $0.font = UIFont.systemFont(ofSize: 12)
        $0.textAlignment = .right
        $0.text = "1231"
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func setUpHierarchy() {
        contentView.addSubview(profileImage)
        contentView.addSubview(blackImage)
        blackImage.addSubview(star)
        blackImage.addSubview(likesCount)
    }
    override func setUpLayout() {
        profileImage.snp.makeConstraints { make in
            make.edges.equalTo(contentView.safeAreaLayoutGuide)
        }
        blackImage.snp.makeConstraints { make in
            make.leading.bottom.equalTo(contentView.safeAreaLayoutGuide).inset(8)
            make.height.equalTo(30)
            make.width.equalTo(80)
        }
        star.snp.makeConstraints { make in
            make.size.equalTo(20)
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(10)
        }
        likesCount.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(10)
            make.leading.equalTo(star.snp.trailing)
            make.centerY.equalToSuperview()
        }
        
    }
    func updateUI(_ i: Int) {
        profileImage.image = UIImage(systemName: "star")
        profileImage.backgroundColor = .red
    }
}
