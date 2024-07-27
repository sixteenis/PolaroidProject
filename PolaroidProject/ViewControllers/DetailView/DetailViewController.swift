//
//  DetailViewController.swift
//  PolaroidProject
//
//  Created by 박성민 on 7/24/24.
//

import UIKit
import SnapKit
import Then

final class DetailViewController: BaseViewController {
    let userProfile = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = $0.frame.width / 2
    }
    let userName = UILabel().then {
        $0.font = .systemFont(ofSize: 12)
        $0.textColor = .cBlack
        $0.numberOfLines = 1
        $0.textAlignment = .left
    }
    let DateLabel = UILabel().then {
        $0.font = .boldSystemFont(ofSize: 12)
        $0.textColor = .cBlack
        $0.numberOfLines = 1
        $0.textAlignment = .left
    }
    lazy var likeButton = UIButton().then {
        $0.setTitle("", for: .normal)
        $0.backgroundColor = .cWhite
        $0.setTitleColor(.cBlue, for: .normal)
        $0.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
    }
    let image = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.masksToBounds = true
    }
    let informationLabel = UILabel().then {
        $0.text = "정보"
        $0.textColor = .cBlack
        $0.font = .heavy20
        $0.textAlignment = .left
    }
    let sizeLabel = InformationLabelView(frame: .zero, title: "크기")
    let hitsLabel = InformationLabelView(frame: .zero, title: "조회수")
    let downloadedLabel = InformationLabelView(frame: .zero, title: "다운로드")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        testSetup()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    override func setUpHierarchy() {
        view.addSubview(userProfile)
        view.addSubview(userName)
        view.addSubview(DateLabel)
        view.addSubview(likeButton)
        view.addSubview(image)
        view.addSubview(informationLabel)
        view.addSubview(sizeLabel)
        view.addSubview(hitsLabel)
        view.addSubview(downloadedLabel)
    }
    override func setUpLayout() {
        userProfile.snp.makeConstraints { make in
            make.top.leading.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.size.equalTo(35)
        }
        userName.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.leading.equalTo(userProfile.snp.trailing).offset(10)
        }
        DateLabel.snp.makeConstraints { make in
            make.top.equalTo(userName.snp.bottom).offset(3)
            make.leading.equalTo(userProfile.snp.trailing).offset(10)
        }
        likeButton.snp.makeConstraints { make in
            make.top.trailing.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.size.equalTo(35)
        }
        image.snp.makeConstraints { make in
            make.top.equalTo(userProfile.snp.bottom)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(180)
        }
        informationLabel.snp.makeConstraints { make in
            make.top.equalTo(image.snp.bottom).offset(10)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
        sizeLabel.snp.makeConstraints { make in
            make.top.equalTo(image.snp.bottom).offset(10)
            make.leading.equalTo(informationLabel.snp.trailing).offset(40)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(20)
        }
        hitsLabel.snp.makeConstraints { make in
            make.top.equalTo(sizeLabel.snp.bottom).offset(15)
            make.leading.equalTo(informationLabel.snp.trailing).offset(40)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(20)
        }
        downloadedLabel.snp.makeConstraints { make in
            make.top.equalTo(hitsLabel.snp.bottom).offset(15)
            make.leading.equalTo(informationLabel.snp.trailing).offset(40)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(20)
        }
    }
    func testSetup() {
        userProfile.image = UIImage(systemName: "star")
        userName.text = "감자 고구마"
        DateLabel.text = "2024년 7월 30일 게시됨"
        likeButton.setImage(UIImage(systemName: "star"), for: .normal)
        image.image = UIImage(systemName: "star")
        sizeLabel.setUpMaintitle("3098X3000")
        hitsLabel.setUpMaintitle("1,231,23,123,1")
        downloadedLabel.setUpMaintitle("3030393298")
    }
}

private extension DetailViewController {
    @objc func likeButtonTapped() {
        
    }
}
