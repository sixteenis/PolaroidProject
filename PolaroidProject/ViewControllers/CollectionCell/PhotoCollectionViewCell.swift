//
//  TopicCollectionViewCell.swift
//  PolaroidProject
//
//  Created by 박성민 on 7/24/24.
//

import UIKit

import SnapKit
import Then
import Kingfisher

class PhotoCollectionViewCell: BaseCollectioViewCell {
    let profileImage = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.masksToBounds = true
    }
    let blackImage = UIView().then {
        $0.backgroundColor = .cKhaki
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 15
    }
    let likeButton = UIButton().then {
        $0.setTitle("", for: .normal)
        $0.setTitleColor(.cBlack, for: .normal)
    }
    let star = UIImageView().then {
        $0.image = UIImage(systemName: "star.fill")
        $0.contentMode = .scaleAspectFit 
        $0.tintColor = .systemYellow
    }
    let likesCount = UILabel().then {
        $0.textColor = .cWhite
        $0.numberOfLines = 1
        $0.font = UIFont.systemFont(ofSize: 11)
        $0.textAlignment = .center
    }
    var completion: (() -> ())?
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func setUpHierarchy() {
        contentView.addSubview(profileImage)
        contentView.addSubview(blackImage)
        contentView.addSubview(likeButton)
        blackImage.addSubview(star)
        blackImage.addSubview(likesCount)
        
        likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        
    }
    override func setUpLayout() {
        profileImage.snp.makeConstraints { make in
            make.edges.equalTo(contentView.safeAreaLayoutGuide)
        }
        blackImage.snp.makeConstraints { make in
            make.leading.bottom.equalTo(contentView.safeAreaLayoutGuide).inset(8)
            make.height.equalTo(30)
            make.width.equalTo(70)
        }
        star.snp.makeConstraints { make in
            make.size.equalTo(17)
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(7)
        }
        likesCount.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(7)
            make.leading.equalTo(star.snp.trailing)
            make.centerY.equalToSuperview()
        }
        likeButton.snp.makeConstraints { make in
            make.trailing.bottom.equalToSuperview().inset(8)
        }
        
    }
    func updateUI(_ data: ImageDTO, style: CollectionType) {
        switch style {
        case .topic:
            profileImage.layer.cornerRadius = 15
            likeButton.isHidden = true
            blackImage.isHidden = false
        case .search:
            likeButton.isHidden = false
            blackImage.isHidden = false
            
        }
        checkLike(data.imageId)
        
        profileImage.kf.indicatorType = .activity
        guard let url = URL(string: data.urls.small) else { return }
        profileImage.kf.setImage(
        with: url,
        placeholder: nil,
        options: [.transition(.fade(1.2))]
        )
        
        likesCount.text = data.likes.formatted()
    }
    func updateUIWithRelam(_ data: LikeList) {
        likeButton.isHidden = false
        blackImage.isHidden = true
        checkLike(data.imageId)
        
        profileImage.image = LikeRepository.shard.getImage(data.imageId)
        
    }
    func checkLike(_ id: String) {
        let result = LikeRepository.shard.checklist(id)
        if result {
            likeButton.setImage(UIImage(named: "like_circle"), for: .normal)
        }else{
            
            likeButton.setImage(UIImage(named: "like_circle_inactive"), for: .normal)
        }
    }
    @objc func likeButtonTapped() {
        self.completion?()
        
    }
}