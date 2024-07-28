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
    private let userProfile = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.masksToBounds = true
    }
    private let userName = UILabel().then {
        $0.font = .systemFont(ofSize: 12)
        $0.textColor = .cBlack
        $0.numberOfLines = 1
        $0.textAlignment = .left
    }
    private let DateLabel = UILabel().then {
        $0.font = .boldSystemFont(ofSize: 12)
        $0.textColor = .cBlack
        $0.numberOfLines = 1
        $0.textAlignment = .left
    }
    private lazy var likeButton = UIButton().then {
        $0.setTitle("", for: .normal)
        $0.backgroundColor = .cWhite
        $0.setTitleColor(.cBlack, for: .normal)
        $0.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
    }
    private let image = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.masksToBounds = true
    }
    private let informationLabel = UILabel().then {
        $0.text = "정보"
        $0.textColor = .cBlack
        $0.font = .heavy20
        $0.textAlignment = .left
    }
    private let sizeLabel = InformationLabelView(frame: .zero, title: "크기")
    private let hitsLabel = InformationLabelView(frame: .zero, title: "조회수")
    private let downloadedLabel = InformationLabelView(frame: .zero, title: "다운로드")
    
    let vm = DetailViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.vm.inputViewWillDisappear.value = ()

        self.tabBarController?.tabBar.isHidden = false
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.userProfile.layer.cornerRadius = self.userProfile.frame.width / 2
    }
    override func bindData() {
        vm.outputlikeBool.bind(true) { [weak self] bool in
            guard let bool else { return }
            bool ? self?.likeButton.setImage(UIImage(named: "like"), for: .normal) : self?.likeButton.setImage(UIImage(named: "like_inactive"), for: .normal)
        }
        vm.outputSetModel.bind(true) { [weak self]  model in
            guard let model else { return }
            self?.setUpModel(model)
        }
        vm.outputImage.bind { [weak self]  data in
            self?.setUpImage(data)
        }
        vm.outputUserprofile.bind { [weak self] data in
            self?.setUpUserprofile(data)
        }
        vm.outputID.bind(true) { [weak self] ids in
            guard let self,let id = ids.0, let userid = ids.1 else {return}
            self.setUpWithRealm(id, userId: userid)
        }
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
            make.top.equalTo(userProfile.snp.bottom).offset(10)
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
}

private extension DetailViewController {
    @objc func likeButtonTapped() {
        vm.inputLikeButton.value = ()
    }
    func setUpModel(_ model: DetailSettingModel) {
        userName.text = model.userName
        DateLabel.text = model.filterDate
        sizeLabel.setUpMaintitle(model.size)
        hitsLabel.setUpMaintitle(model.hits)
        downloadedLabel.setUpMaintitle(model.download)
    }
    func setUpImage(_ imageURL: String?) {
        if let imageURL {
            let url = URL(string: imageURL)!
            self.image.kf.setImage(with: url)
        }
    }
    func setUpUserprofile(_ imageURL: String?) {
        if let imageURL {
            let url = URL(string: imageURL)!
            self.userProfile.kf.setImage(with: url)
        }
    }
    
    func setUpWithRealm(_ id: String, userId: String) {
        self.image.image = LikeRepository.shard.getImage(id)
        self.userProfile.image = LikeRepository.shard.getImage(userId)
    }
}
