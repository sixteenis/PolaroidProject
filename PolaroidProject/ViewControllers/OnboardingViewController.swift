//
//  OnboardingViewController.swift
//  PolaroidProject
//
//  Created by 박성민 on 7/22/24.
//

import UIKit

import SnapKit
import Then

final class OnboardingViewController: BaseViewController {
    private let onbardingTitle = UIImageView().then {
        $0.image = UIImage.launch
    }
    private let onbardingImage = UIImageView().then {
        $0.image = UIImage.launchImageCar
        $0.contentMode = .scaleToFill
        $0.backgroundColor = .red
    }
    private let myName = UILabel().then {
        $0.text = "박성민"
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 33)
    }
    private var startButton = SuccessButton("시작하기")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startButton.alpha = 0
        animationImageView()
    }
    
    override func setUpHierarchy() {
        view.addSubview(onbardingTitle)
        view.addSubview(onbardingImage)
        view.addSubview(myName)
        view.addSubview(startButton)
        startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
    }
    override func setUpLayout() {
        onbardingTitle.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(40)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(30)
            make.height.equalTo(120)
        }
        onbardingImage.snp.makeConstraints { make in
            make.top.equalTo(onbardingTitle.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.height.equalTo(onbardingImage.snp.width)
        }
        myName.snp.makeConstraints { make in
            make.top.equalTo(onbardingImage.snp.bottom).offset(40)
            make.centerX.equalTo(view.safeAreaLayoutGuide)
        }
        startButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(45)
        }
    }
    
    // MARK: - 시작 버튼 함수
    @objc func startButtonTapped() {
        let vc = LoginViewController()
        vc.vm.settingType = .onboarding
        print("11")
        navigationController?.pushViewController(vc, animated: true)
        
    }
    private func animationImageView() {
        UIView.animate(withDuration: 1, delay: 0.5, options: .curveEaseInOut) {
            self.startButton.alpha = 1
        }
    }
}
