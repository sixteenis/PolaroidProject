//
//  SelectProfileViewController.swift
//  PolaroidProject
//
//  Created by 박성민 on 7/22/24.
//

import UIKit
import SnapKit

final class SelectProfileViewController: BaseViewController {
    private let line = UIView()
    private lazy var profileImage = MainProfileImageView()
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
    private static func collectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.width - 50
        layout.itemSize = CGSize(width: width/4, height: width/4)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        return layout
    }
    
    let vm = SelectProfileViewModel()
    var completion: ((String) -> Void)?
    var navTitle: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCollectionView()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.completion?(vm.outputProfileImage.value!)
    }
    override func bindData() {
        vm.outputProfileImage.bind(true) { [weak self] image in
            guard let image, let self else {return}
            self.profileImage.changeProfile(image)
            self.collectionView.reloadData()
        }
    }
    // MARK: - connect 부분
    override func setUpHierarchy() {
        view.addSubview(line)
        view.addSubview(profileImage)
        view.addSubview(collectionView)
    }
    // MARK: - Layout 부분
    override func setUpLayout () {
        line.snp.makeConstraints { make in
            make.horizontalEdges.top.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(1)
        }
        profileImage.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.centerX.equalTo(view.safeAreaLayoutGuide)
            make.size.equalTo(view.snp.width).multipliedBy(0.3)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(profileImage.snp.bottom).offset(20)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    // MARK: - UI 세팅 부분
    override func setUpView() {
        line.backgroundColor = .cGray
        navigationItem.title = navTitle
    }
    // MARK: - Collection 세팅 부분
    private func setUpCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(SelectProfileCollectionViewCell.self, forCellWithReuseIdentifier: SelectProfileCollectionViewCell.id)
        collectionView.backgroundColor = .cWhite
        
        collectionView.reloadData()
    }
    
}
// MARK: - collection 부분
extension SelectProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ProfileImage.allCases.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SelectProfileCollectionViewCell.id, for: indexPath) as! SelectProfileCollectionViewCell
        let data = ProfileImage.allCases[indexPath.row].image
        let selectBool = data == vm.outputProfileImage.value
        cell.backgroundColor = .white
        cell.setUpData(data, select: selectBool)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        vm.inputSelectProfile.value = indexPath.row
    }
}
