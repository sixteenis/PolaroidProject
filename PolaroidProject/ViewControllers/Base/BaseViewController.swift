//
//  BaseViewController.swift
//  MeaningOutProject
//
//  Created by 박성민 on 7/23/24.
//

import UIKit

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .cWhite
        setUpHierarchy()
        setUpView()
        setUpLayout()
        bindData()
        setUpNavLeft()
    }
    
    func setUpHierarchy() {}
    func setUpLayout() {}
    func setUpView() {}
    func bindData() {}
    func setUpNavLeft() {
        self.navigationController?.navigationBar.topItem?.title = ""
        navigationController?.navigationBar.tintColor = .cBlack
    }
}
