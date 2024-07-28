//
//  TopicViewController.swift
//  PolaroidProject
//
//  Created by 박성민 on 7/23/24.
//

import UIKit

import SnapKit
import Then

final class TopicViewController: BaseViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<TopicSection,ImageModel>
    typealias Snapshot = NSDiffableDataSourceSnapshot<TopicSection, ImageModel>
    typealias Registration = UICollectionView.CellRegistration<PhotoCollectionViewCell, ImageModel>
    
    private let loadingIndicator = UIActivityIndicatorView(style: .large)
    private let errorView = ErrorView(frame: .zero)
    private lazy var navRightBar = SelcetProfileImageView()
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    private let test = TopicSectionHeaderReusableView()
    private var dataSource:DataSource!
    
    private let vm = TopicViewModel()
    private var refreshTimer: Timer?
    private var refreshCanBool = true
    override func viewDidLoad() {
        super.viewDidLoad()
        vm.inputViewDidLoad.value = ()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .automatic
        navigationItem.title = "OUR TOPIC"
        vm.inputCheckProfile.value = ()
    }
    override func bindData() {
        vm.outputErrorTitle.bind { err in
            self.errorView.isHidden = false
            self.errorView.getErrorText(err)
        }
        vm.outputLoadingSet.bind(true) { bool in
            bool ? self.hideLoadingIndicator() : self.showLoadingIndicator()
        }
        vm.outputGetProfileImage.bind { [weak self] image in
            guard let self, let image else { return }
            navRightBar.changeProfile(image)
        }
        vm.outputTopicList.bind { topicModel in
            self.setUpDataSource()
            self.upDateSnapshot(topics: topicModel)
            
        }
    }
    
    override func setUpHierarchy() {
        view.addSubview(navRightBar)
        view.addSubview(collectionView)
        view.addSubview(test)
        view.addSubview(errorView)
    }
    override func setUpLayout() {
        navRightBar.snp.makeConstraints { make in
            make.size.equalTo(35)
        }
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        errorView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    override func setUpView() {
        let navright = UIBarButtonItem(customView: navRightBar)
        navigationItem.rightBarButtonItem = navright
        let tap = UITapGestureRecognizer(target: self, action: #selector(navrightButtonTapped))
        navRightBar.addGestureRecognizer(tap)
        errorView.isHidden = true
        
        collectionView.delegate = self
        collectionView.register(TopicSectionHeaderReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TopicSectionHeaderReusableView.id)
        collectionView.refreshControl = UIRefreshControl()
        collectionView.refreshControl?.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
    }
}
// MARK: - collectionView 델리게이트 부분, 다음 화면으로 이동하는 부분
extension TopicViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = dataSource.itemIdentifier(for: indexPath)
        guard let data else {return}
        let likeBool = LikeRepository.shard.checklist(data.data.imageId)
        let vc = DetailViewController()
        if likeBool {
            let item = LikeRepository.shard.getLikeList(data.data.imageId)
            vc.vm.inputpushRelamVC.value = item
        }else{
            vc.vm.inputpushVC.value = data.data
        }
        navigationController?.pushViewController(vc, animated: true)
        
    }
}
// MARK: - 버튼 기능 부분
private extension TopicViewController {
    @objc func navrightButtonTapped() {
        let vc = LoginViewController()
        vc.vm.settingType = .setting
        navigationController?.pushViewController(vc, animated: true)
    }
    @objc func handleRefreshControl() {
        self.collectionView.refreshControl?.endRefreshing()
        guard refreshCanBool else {return} //ture가 아니면 벗어남
        
        
        self.vm.inputViewDidLoad.value = () //네트워킹 해주고
        self.refreshCanBool = false
        self.refreshTimer?.invalidate()
        self.refreshTimer = Timer.scheduledTimer(withTimeInterval: 60, repeats: false) { [weak self] _ in
            self?.refreshCanBool = true
        }
        
        
    }
}

// MARK: - collectionView 레이아웃 부분
private extension TopicViewController {
    func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.4))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(10)
        
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
    func upDateSnapshot(topics: [TopicSeciontModel]) {
        var snapshot = Snapshot()
        snapshot.appendSections(topics.map{$0.section})
        topics.forEach { topic in
            snapshot.appendItems(topic.topicList, toSection: topic.section)
        }
        dataSource.apply(snapshot)
    }
    
    func setUpDataSource() {
        let using = TopicCellRegistration()
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: using, for: indexPath, item: itemIdentifier)
            return cell
            
        }
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard kind == UICollectionView.elementKindSectionHeader else { return nil }
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TopicSectionHeaderReusableView.id, for: indexPath) as! TopicSectionHeaderReusableView
            let section = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
            view.titleLabel.text = section.setionTitle
            return view
        }
    }
    func TopicCellRegistration() -> Registration {
        let result = Registration { cell, indexPath, itemIdentifier in
            cell.updateUI(itemIdentifier.data, style: .topic)
        }
        return result
    }
}
// MARK: - 리로딩 뷰 관련 코드
private extension TopicViewController {
    private func showLoadingIndicator() {
        loadingIndicator.startAnimating()
        loadingIndicator.center = view.center
        view.addSubview(loadingIndicator)
    }
    
    private func hideLoadingIndicator() {
        loadingIndicator.stopAnimating()
        loadingIndicator.removeFromSuperview()
    }
}

