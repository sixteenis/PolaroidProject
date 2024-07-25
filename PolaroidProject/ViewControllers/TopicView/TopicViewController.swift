//
//  TopicViewController.swift
//  PolaroidProject
//
//  Created by 박성민 on 7/23/24.
//

import UIKit

import SnapKit

enum Section: String,CaseIterable {
    case firest = "골든 아워"
    case second = "비즈니스 및 업무"
    case thride = "건축 및 인테리어"
}

// TODO: 프로필을 변경 후에 네비 프로필 이미지 다시 세팅해주는 로직 작성
// TODO: 서버 통신 ㄱㄱ
// TODO: cell 뷰 만들기
final class TopicViewController: BaseViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<Section,Int>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Int>
    typealias Registration = UICollectionView.CellRegistration<TopicCollectionViewCell, Int>
    
    private lazy var navRightBar = SelcetProfileImageView()
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    private let test = TopicSectionHeaderReusableView()
    private var dataSource:DataSource!
    
    private let vm = TopicViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vm.inputViewDidLoad.value = ()
        setUpDataSource()
        upDateSnapshot()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .automatic
        navigationItem.title = "OUR TOPIC"
//        let a = TopicSection.allCases
//        UnsplashNetworkManager.shard.requestTopic(type: a[0])
        let a = SearchParams(query: "고양이", page: "1", orderby: .latest, color: nil)
        UnsplashNetworkManager.shard.requestSearch(type: a)
    }
    override func bindData() {
        vm.outputGetProfileImage.bind { [weak self] image in
            guard let self, let image else { return }
            navRightBar.changeProfile(image)
        }
    }
    
    override func setUpHierarchy() {
        view.addSubview(navRightBar)
        view.addSubview(collectionView)
        view.addSubview(test)
    }
    override func setUpLayout() {
        navRightBar.snp.makeConstraints { make in
            make.size.equalTo(35)
        }
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    override func setUpView() {
        let navright = UIBarButtonItem(customView: navRightBar)
        navigationItem.rightBarButtonItem = navright
        let tap = UITapGestureRecognizer(target: self, action: #selector(navrightButtonTapped))
        navRightBar.addGestureRecognizer(tap)
        
        collectionView.delegate = self
        collectionView.register(TopicSectionHeaderReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TopicSectionHeaderReusableView.id)
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

// MARK: - collectionView 레이아웃 부분
private extension TopicViewController {
    func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .absolute(200))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(220))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(30)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 10
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 10)
        
        // 헤더 뷰 추가
        let header = self.makeHeaderView(elementKind: UICollectionView.elementKindSectionHeader)
        section.boundarySupplementaryItems = [header]
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    func makeHeaderView(elementKind: String) -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(50))
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: elementKind,
            alignment: .top)
        
        return header
    }
}
// MARK: - DataSource 관련 코드
private extension TopicViewController {
    func upDateSnapshot() {
        var snapshot = Snapshot()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems([1,2,3], toSection: .firest)
        snapshot.appendItems([4,5], toSection: .second)
        snapshot.appendItems([6,7,8], toSection: .thride)
        dataSource.apply(snapshot)
    }
    func setUpDataSource() {
        let using = phtoCellRegistration()
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: using, for: indexPath, item: itemIdentifier)
            //여기다 cell부분 넣으면 됨 ㅇㅇ
            return cell
            
        }
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard kind == UICollectionView.elementKindSectionHeader else { return nil }
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TopicSectionHeaderReusableView.id, for: indexPath) as! TopicSectionHeaderReusableView
            let section = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
            view.titleLabel.text = section.rawValue
            return view
        }
    }
    func phtoCellRegistration() -> Registration {
        let result = Registration { cell, indexPath, itemIdentifier in
            cell.updateUI(itemIdentifier)
        }
        return result
    }
}
// MARK: - collectionView 델리게이트 부분
extension TopicViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = dataSource.itemIdentifier(for: indexPath)
        let vc = DetailViewController()
        print(data!)
    }
}
