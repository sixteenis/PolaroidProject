//
//  startButtonView.swift
//  PolaroidProject
//
//  Created by 박성민 on 7/22/24.
//

import UIKit

final class SuccessButton: UIButton {
    init(_ title: String, bool: Bool = true) {
        super.init(frame: .zero)
        setTitle(title, for: .normal)
        setTitleColor(.cWhite, for: .normal)
        toggleColor(bool)
        contentMode = .center
        layer.cornerRadius = .CG20
    }
    func toggleColor(_ bool: Bool) {
        backgroundColor = bool ? .cBlue : .cGray
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
