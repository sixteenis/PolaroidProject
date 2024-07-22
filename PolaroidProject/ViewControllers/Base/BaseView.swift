//
//  BaseView.swift
//  MeaningOutProject
//
//  Created by 박성민 on 6/25/24.
//
import UIKit

class BaseView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpHierarchy()
        setUpLayout()
        setUpView()
        self.backgroundColor = .cWhite
    }
    func setUpHierarchy() { }
    func setUpLayout() { }
    func setUpView() { }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
