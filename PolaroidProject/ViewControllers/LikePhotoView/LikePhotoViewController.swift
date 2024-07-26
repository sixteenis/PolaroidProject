//
//  LikePhotoViewController.swift
//  PolaroidProject
//
//  Created by 박성민 on 7/24/24.
//

import UIKit

import SnapKit
import Then
enum LikePhotoSection: CaseIterable {
    case firest
}
final class LikePhotoViewController: BaseViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<LikePhotoSection,ImageDTO>
    typealias Snapshot = NSDiffableDataSourceSnapshot<LikePhotoSection, ImageDTO>
    typealias Registration = UICollectionView.CellRegistration<PhotoCollectionViewCell, ImageDTO>
    
    private let sortingButton = UIButton().then {
        $0.setTitle("정렬", for: .normal)
        $0.setTitleColor(.cBlack, for: .normal)
        $0.backgroundColor = .cWhite
    }
    private let line = UIView().then {
        $0.backgroundColor = .cGray
    }
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    private var dataSource: DataSource!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpDataSource()
        upDateSnapshot()

    }
    override func setUpHierarchy() {
        view.addSubview(line)
        view.addSubview(sortingButton)
        view.addSubview(collectionView)
        
        sortingButton.addTarget(self, action: #selector(sortingButtonTapped), for: .touchUpInside)
        collectionView.delegate = self
        
    }
    override func setUpLayout() {
        line.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(5)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(1)
        }
        sortingButton.snp.makeConstraints { make in
            make.top.equalTo(line.snp.bottom).offset(10)
            make.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(33)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(sortingButton.snp.bottom).offset(10)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    override func setUpView() {
        navigationItem.title = "MY POLAROID"
    }
    
}
// MARK: - 버튼 기능 부분
private extension LikePhotoViewController {
    @objc func navrightButtonTapped() {
        let vc = LoginViewController()
        vc.vm.settingType = .setting
        navigationController?.pushViewController(vc, animated: true)
    }
    @objc func sortingButtonTapped() {
        print(#function)
    }
}
// MARK: - collectionView 델리게이트 부분
extension LikePhotoViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = dataSource.itemIdentifier(for: indexPath)
        let vc = DetailViewController()
        print(data!)
    }
}
// MARK: - collectionView 레이아웃 부분
private extension LikePhotoViewController {
    func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .absolute(200))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(1.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(5)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
}
// MARK: - DataSource 관련 코드
private extension LikePhotoViewController {
    func upDateSnapshot() {
        var snapshot = Snapshot()
        snapshot.appendSections(LikePhotoSection.allCases)
//        /snapshot.appendItems([1,2,3,4,5,6,7,8,9,10], toSection: .firest)
        
        dataSource.apply(snapshot)
    }
    func setUpDataSource() {
        let using = phtoCellRegistration()
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: using, for: indexPath, item: itemIdentifier)
            //여기다 cell부분 넣으면 됨 ㅇㅇ
            return cell
            
        }

    }
    func phtoCellRegistration() -> Registration {
        let result = Registration { cell, indexPath, itemIdentifier in
            cell.updateUI(itemIdentifier, style: .likeList)
        }
        return result
    }
}

