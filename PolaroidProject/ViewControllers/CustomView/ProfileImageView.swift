//
//  ProfileImageView.swift
//  MeaningOutProject
//
//  Created by 박성민 on 6/13/24.
//

import UIKit

import SnapKit

class SelcetProfileImageView: UIView {
    fileprivate let mainImageView = UIImageView()
    init(profile: String = "profile_0") {
        super.init(frame: .zero)
        setUpMainImage(profile)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        mainImageView.layer.cornerRadius = mainImageView.frame.width / 2
    }
    
    // MARK: - 메인 이미지 셋업 부분
    private func setUpMainImage(_ profile: String) {
        self.addSubview(mainImageView)
        self.mainImageView.image = UIImage(named: profile)
        self.mainImageView.layer.borderColor = UIColor.cBlue.cgColor
        self.mainImageView.layer.borderWidth = 3
        self.mainImageView.clipsToBounds = true
        
        mainImageView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
        
    }
    func selectedProfile(_ data: String, select: Bool) {
        if !select {
            self.mainImageView.layer.borderWidth = 1
            self.mainImageView.layer.borderColor = UIColor.cGray.cgColor
            self.alpha = 0.5
            
        }else{
            self.mainImageView.layer.borderWidth = 3
            self.mainImageView.layer.borderColor = UIColor.cBlue.cgColor
            self.alpha = 1
        }
        self.mainImageView.image = UIImage(named: data)
    }
    func changeProfile(_ image: String) {
        mainImageView.image = UIImage(named: image)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// MARK: - 카메라 달린 프로필
final class MainProfileImageView: SelcetProfileImageView {
    
    private let subImageView = UIImageView()
    
    
    override init(profile: String = "profile_0") {
        super.init(profile: profile)
        
        setUpSubImage()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        subImageView.layer.cornerRadius = subImageView.frame.width / 2
    }
    // MARK: - 서브 이미지 셋업 부분
    private func setUpSubImage() {
        self.addSubview(subImageView)
        
        subImageView.snp.makeConstraints { make in
            make.size.equalTo(self.snp.height).multipliedBy(0.3)
            make.bottom.equalTo(self.snp.bottom).inset(5)
            make.trailing.equalTo(self.snp.trailing)
            
        }
    
        subImageView.image = UIImage(systemName: "camera.fill")
        subImageView.tintColor = .cWhite
        subImageView.backgroundColor = .cBlue
        subImageView.clipsToBounds = true
        subImageView.contentMode = .center
    }
    
    
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
