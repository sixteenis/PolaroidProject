//
//  MBTIButtonView.swift
//  PolaroidProject
//
//  Created by 박성민 on 7/22/24.
//

import UIKit
import SnapKit
final class MBTIButtonView: BaseView {
    private let topButton = UIButton()
    private let bottomButton = UIButton()
    var buttonIndex: Int = 0
    var completion: ((Int, Int) -> Void)?
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    init(frame: CGRect,top: String, bottom: String, buttonIndex: Int) {
        self.topButton.setTitle(top, for: .normal)
        self.bottomButton.setTitle(bottom, for: .normal)
        self.buttonIndex = buttonIndex
        super.init(frame: frame)
        backgroundColor = .red
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        topButton.layer.cornerRadius = topButton.frame.width / 2
        bottomButton.layer.cornerRadius = bottomButton.frame.width / 2
    }
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        topButton.layer.masksToBounds = true
        bottomButton.layer.masksToBounds = false
        
    }
    
    
    override func setUpHierarchy() {
        addSubview(topButton)
        addSubview(bottomButton)
        topButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        bottomButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
    }
    
    override func setUpLayout() {
        topButton.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide)
            make.size.equalTo(45)
            make.centerX.equalTo(self.safeAreaLayoutGuide)
        }
        bottomButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.safeAreaLayoutGuide)
            make.size.equalTo(45)
            make.centerX.equalTo(self.safeAreaLayoutGuide)
        }
    }
    override func setUpView() {
        topButton.tag = 0
        bottomButton.tag = 1
        topButton.layer.borderColor = UIColor.cGray.cgColor
        bottomButton.layer.borderColor = UIColor.cGray.cgColor
        topButton.setTitleColor(.cBlack, for: .normal)
        bottomButton.setTitleColor(.cBlack, for: .normal)
        topButton.layer.borderWidth = 3
        bottomButton.layer.borderWidth = 3
        topButton.backgroundColor = .lightGray
        bottomButton.backgroundColor = .lightGray
        
    }
    @objc func buttonTapped(_ sender: UIButton) {
        completion?(self.buttonIndex,sender.tag)
    }
}
