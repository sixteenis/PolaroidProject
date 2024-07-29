//
//  FilterButtonCollectioViewCell.swift
//  PolaroidProject
//
//  Created by 박성민 on 7/29/24.
//

import UIKit

import SnapKit

class FilterButtonCollectioViewCell: BaseCollectioViewCell {
    private let sortingButton = UIButton().then {
        $0.setTitleColor(.cBlack, for: .normal)
        $0.setImage(UIImage(named: "sort"), for: .normal)
        $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        $0.backgroundColor = .cWhite
        $0.layer.masksToBounds = true
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.cGray.cgColor
        $0.layer.cornerRadius = 15
    }
    override func setUpHierarchy() {
        self.addSubview(sortingButton)
    }
    override func setUpLayout() {
        sortingButton.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
    }
    func setUpButton(_ type: SearchColor) {
        sortingButton.setTitle(type.descritpion, for: .normal)
    }
}
