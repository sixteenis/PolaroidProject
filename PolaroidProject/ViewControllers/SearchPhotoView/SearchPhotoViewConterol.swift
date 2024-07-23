//
//  SearchPhotoView.swift
//  PolaroidProject
//
//  Created by 박성민 on 7/23/24.
//

import UIKit

import SnapKit
final class SearchPhotoViewConterol: BaseViewController {
    let button = UIButton()
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func setUpHierarchy() {
        view.addSubview(button)
        button.snp.makeConstraints { make in
            make.center.equalTo(view.safeAreaLayoutGuide)
            make.size.equalTo(50)
        }
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.setTitle("asdasd", for: .normal)
        button.setTitleColor(.black, for: .normal)
    }
    override func setUpLayout() {
        
    }
    @objc func buttonTapped() {
        for key in UserDefaults.standard.dictionaryRepresentation().keys {
            UserDefaults.standard.removeObject(forKey: key.description)
        }
    }
}
