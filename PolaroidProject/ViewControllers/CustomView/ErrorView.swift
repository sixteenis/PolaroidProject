//
//  ErorrView.swift
//  PolaroidProject
//
//  Created by 박성민 on 7/26/24.
//

import UIKit

import Then

final class ErrorView: BaseView {
    private let titleLabel = UILabel().then {
        $0.font = .boldSystemFont(ofSize: 18)
        $0.textColor = .cBlack
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    private let errImage = UIImageView().then {
        $0.image = UIImage.launchImageCar
        $0.contentMode = .scaleAspectFit
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    override func setUpHierarchy() {
        self.addSubview(titleLabel)
        self.addSubview(errImage)
    }
    override func setUpLayout() {
        errImage.snp.makeConstraints { make in
            make.edges.horizontalEdges.equalTo(safeAreaLayoutGuide)
        }
        titleLabel.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide).inset(50)
            make.centerX.equalTo(safeAreaLayoutGuide)
        }
    }
    func getErrorText(_ err: String) {
        self.titleLabel.text = err
    }
    
}
