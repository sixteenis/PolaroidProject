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
        $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        $0.backgroundColor = .cWhite
        $0.setImage(UIImage(systemName: "circle.fill"), for: .normal)
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 15
    }
    var completion: (() -> ())?
    override func setUpHierarchy() {
        self.addSubview(sortingButton)
        self.sortingButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    override func setUpLayout() {
        sortingButton.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
    }
    func setUpButton(_ type: ColorModel) {
        sortingButton.setTitle(" \(type.color.descritpion)", for: .normal)
        sortingButton.imageView?.tintColor = type.color.colorSet
        sortingButton.backgroundColor = .cDarkwhite
        if type.isSelect {
            sortingButton.backgroundColor = .cBlue
        }else {
            sortingButton.backgroundColor = .cDarkwhite
        }
    }

        
        
    
    @objc func buttonTapped() {
        completion?()
    }
}
