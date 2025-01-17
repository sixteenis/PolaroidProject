//
//  TopicViewController.swift
//  PolaroidProject
//
//  Created by 박성민 on 7/23/24.
//
// TODO: 리로딩했을 때 스크롤 인덱스 0으로 만들어주기!
import UIKit

import SnapKit
import Then
import Toast

final class TopicViewController: BaseViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<TopicSection,ImageModel>
    typealias Snapshot = NSDiffableDataSourceSnapshot<TopicSection, ImageModel>
    typealias Registration = UICollectionView.CellRegistration<PhotoCollectionViewCell, ImageModel>
    
    private let loadingIndicator = UIActivityIndicatorView(style: .large)
    private let errorView = ErrorView(frame: .zero)
    private lazy var navRightBar = SelcetProfileImageView()
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    
    private var dataSource:DataSource!
    
    private var refreshTimer: Timer?
    private var refreshCanBool = true //vm 이동 리팩진행하자
    
    private let vm = TopicViewModel()
    
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
        vm.outputErrorTitle.bind { [weak self] err in
            guard let self else { return }
            self.errorView.isHidden = false
            self.errorView.getErrorText(err)
        }
        vm.outputLoadingSet.bind(true) { [weak self] bool in
            guard let self else { return }
            bool ? self.hideLoadingIndicator() : self.showLoadingIndicator()
        }
        vm.outputGetProfileImage.bind { [weak self] image in
            guard let self, let image else { return }
            navRightBar.changeProfile(image)
        }
        vm.outputTopicList.bind { [weak self] topicModel in
            guard let self else { return }
            self.setUpDataSource()
            self.upDateSnapshot(topics: topicModel)
            if !topicModel.isEmpty {
                for section in 0..<self.vm.outputTopicList.value.count {
                    self.collectionView.scrollToItem(at: IndexPath(item: 0, section: section), at: .left, animated: true)
                }
            }
        }
    }
    override func setUpHierarchy() {
        view.addSubview(navRightBar)
        view.addSubview(collectionView)
        view.addSubview(errorView)
        view.addSubview(loadingIndicator)
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
        
        guard refreshCanBool else {
            DispatchQueue.global().async {
                sleep(1)
                DispatchQueue.main.async {
                    self.view.makeToast("잠시 후 다시 시도해 주세요!")
                }
            }
            return
        }
        self.vm.inputViewDidLoad.value = () //네트워킹 해주고
        
        // TODO: 일단 여기 두고 나중에 vm에 넣어서 통신이 완료된! 시점에! 호출!
        DispatchQueue.global().async {
            sleep(1)
            DispatchQueue.main.async {
                self.view.makeToast("TOPIC 리로드 완료!")
                
            }
        }
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
            view.setupTitle(section.setionTitle)
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
    }
    private func hideLoadingIndicator() {
        loadingIndicator.stopAnimating()
        loadingIndicator.removeFromSuperview()
    }
}

