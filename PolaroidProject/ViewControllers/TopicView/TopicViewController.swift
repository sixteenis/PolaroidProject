//
//  TopicViewController.swift
//  PolaroidProject
//
//  Created by 박성민 on 7/23/24.
//

import UIKit

import SnapKit
final class TopicViewController: BaseViewController {
    private lazy var navRightBar = SelcetProfileImageView()
    
    private let vm = TopicViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vm.inputViewDidLoad.value = ()
    }
    override func bindData() {
        vm.outputGetProfileImage.bind { [weak self] image in
            guard let self, let image else { return }
            navRightBar.changeProfile(image)
            navigationItem.title = "OUR TOPIC"
        }
    }
    
    override func setUpHierarchy() {
        view.addSubview(navRightBar)
    }
    override func setUpLayout() {
        navRightBar.snp.makeConstraints { make in
            make.size.equalTo(35)
        }
    }
    override func setUpView() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .automatic
        let navright = UIBarButtonItem(customView: navRightBar)
        navigationItem.rightBarButtonItem = navright
        let tap = UITapGestureRecognizer(target: self, action: #selector(navrightButtonTapped))
        navRightBar.addGestureRecognizer(tap)
    }
}

// MARK: - 버튼 기능 부분
private extension TopicViewController {
    @objc func navrightButtonTapped() {
        let vc = LoginViewController()
        vc.vm.settingType = .setting
        navigationController?.pushViewController(vc, animated: true)
    }
}
