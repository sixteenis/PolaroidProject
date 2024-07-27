//
//  informationLabelView.swift
//  PolaroidProject
//
//  Created by 박성민 on 7/27/24.
//

import UIKit
import Then
import SnapKit
final class InformationLabelView: BaseView {
    let title = UILabel().then {
        $0.textColor = .cBlack
        $0.font = .boldSystemFont(ofSize: 16)
        $0.textAlignment = .left
    }
    let mainTitle = UILabel().then {
        $0.textColor = .cBlack
        $0.font = .boldSystemFont(ofSize: 16)
        $0.numberOfLines = 1
        $0.textAlignment = .right
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    init(frame: CGRect, title: String) {
        super.init(frame: frame)
        self.title.text = title
    }
    override func setUpHierarchy() {
        self.addSubview(title)
        self.addSubview(mainTitle)
    }
    override func setUpLayout() {
        title.snp.makeConstraints { make in
            make.leading.equalTo(self.safeAreaLayoutGuide)
            make.centerY.equalTo(self.safeAreaLayoutGuide)
        }
        mainTitle.snp.makeConstraints { make in
            make.trailing.equalTo(self.safeAreaLayoutGuide)
            make.centerY.equalTo(self.safeAreaLayoutGuide)
        }
    }
    func setUpMaintitle(_ title: String) {
        self.mainTitle.text = title
    }
}
