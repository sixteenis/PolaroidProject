//
//  SearchPhotoViewController.swift
//  PolaroidProject
//
//  Created by 박성민 on 7/23/24.
//
// TODO: Search, LikeView 하나로 합치는 리팩 진행하기.
// TODO: DetailView에 선택한 필터컬러 적용하기.
// TODO: 컬러 클릭했을 경우 검색에 텍스트가 있으면 다시 통신하기
import UIKit

import SnapKit
import Then
import Toast

final class SearchPhotoViewController: BaseViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<DifferSection,ImageModel>
    typealias Snapshot = NSDiffableDataSourceSnapshot<DifferSection, ImageModel>
    typealias Registration = UICollectionView.CellRegistration<PhotoCollectionViewCell, ImageModel>
    
    typealias FilterDateSource = UICollectionViewDiffableDataSource<DifferSection, ColorModel>
    typealias FilterSnapshot = NSDiffableDataSourceSnapshot<DifferSection, ColorModel>
    typealias FilterRegistration = UICollectionView.CellRegistration<FilterButtonCollectioViewCell, ColorModel>
    
    private var dataSource: DataSource!
    private var filterDateSource: FilterDateSource!
    
    private lazy var imageCollectionView = UICollectionView(frame: .zero, collectionViewLayout: createImageLayout())
    private lazy var filterCollectionView = UICollectionView(frame: .zero, collectionViewLayout: createFilterLayout())
    
    private let loadingIndicator = UIActivityIndicatorView(style: .large)
    
    private let sortingButton = UIButton().then {
        $0.setTitleColor(.cBlack, for: .normal)
        $0.setImage(.sortImage, for: .normal)
        $0.titleLabel?.font = .bold15
        $0.backgroundColor = .cWhite
        $0.layer.masksToBounds = true
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.cGray.cgColor
        $0.layer.cornerRadius = .CG15
    }
    private let line = UIView().then {
        $0.backgroundColor = .cGray
    }
    private let searchBar = UISearchBar().then {
        $0.placeholder = Placeholder.searchBar
        $0.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
    }
    private var settingLabel = UILabel().then {
        $0.textColor = .cBlack
        $0.textAlignment = .center
        $0.font = .heavy20
        $0.isHidden = false
    }
    
    private let vm = SearchPhotoViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.vm.inputViewDidLoad.value = ()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "SEARCH PHOTO"
        self.vm.inputViewWillAppear.value = ()
    }
    override func bindData() {
        vm.outputSetTitle.bind(true) { [weak self] title in
            guard let self else { return }
            self.settingLabel.isHidden = false
            self.imageCollectionView.isHidden = true
            self.settingLabel.text = title
        }
        vm.outputLoadingSet.bind(true) { [weak self] bool in
            guard let self else { return }
            bool ? self.hideLoadingIndicator() : self.showLoadingIndicator()
        }
        vm.outputScrollingTop.bind { [weak self] _ in
            guard let self else { return }
            self.imageCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
        }
        //통신을 통해 얻은 데이터
        vm.outputImageList.bind(true) { [weak self] data in
            guard let self else { return }
            self.settingLabel.isHidden = true
            self.imageCollectionView.isHidden = false
            self.setUpDataSource()
            self.upDateSnapshot(items: data)
        }
        //이미 가지고 있는 데이터
        vm.outputSaveImageList.bind(true) { [weak self] data in
            guard let self else { return }
            self.settingLabel.isHidden = true
            self.imageCollectionView.isHidden = false
            self.setUpDataSource()
            self.upDateSnapshot(items: data)
        }
        //필터 버튼 부분
        vm.outputOrderby.bind(true) { [weak self] type in
            guard let self else { return }
            self.sortingButton.setTitle(" \(type.title) ", for: .normal)
        }
        vm.outputColors.bind { [weak self] colors in
            guard let self else { return }
            self.setUpFilterDataSource()
            self.upDateFilterSnapshot(colors)
        }
        vm.outputButtonToggle.bind { [weak self] bool in
            guard let self else { return }
            bool ? view.makeToast(AlertMessage.save) : view.makeToast(AlertMessage.delecte)
        }
    }
    override func setUpHierarchy() {
        view.addSubview(searchBar)
        view.addSubview(line)
        view.addSubview(filterCollectionView)
        view.addSubview(sortingButton)
        view.addSubview(imageCollectionView)
        view.addSubview(settingLabel)
        
        searchBar.delegate = self
        sortingButton.addTarget(self, action: #selector(sortingButtonTapped), for: .touchUpInside)
        imageCollectionView.delegate = self
        imageCollectionView.prefetchDataSource = self
        
    }
    override func setUpLayout() {
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.height.equalTo(44)
        }
        line.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(1)
        }
        sortingButton.snp.makeConstraints { make in
            make.top.equalTo(line.snp.bottom).offset(10)
            make.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(33)
        }
        filterCollectionView.snp.makeConstraints { make in
            make.top.equalTo(line.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(33)
        }
        imageCollectionView.snp.makeConstraints { make in
            make.top.equalTo(sortingButton.snp.bottom).offset(10)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        settingLabel.snp.makeConstraints { make in
            make.center.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
// MARK: - 버튼 기능 부분
private extension SearchPhotoViewController {
    @objc func sortingButtonTapped() {
        vm.inputFilterButtonTapped.value = ()
    }
}
// MARK: - collectionView 델리게이트 부분, 다음 뷰로 이동 부분
extension SearchPhotoViewController: UICollectionViewDelegate {
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
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
}
// MARK: - 서치바 델리게이트 부분
extension SearchPhotoViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if vm.inputStartNetworking.value != searchBar.text! {
            vm.inputStartNetworking.value = searchBar.text!
        }
        searchBar.resignFirstResponder()
    }
    
}
// MARK: - 페이지네이션 부분
extension SearchPhotoViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        // TODO: vm으로 뺄까 고민해보자
        if indexPaths[0].item == vm.outputImageList.value.count - 4 {
            vm.inputPage.value = indexPaths[0].item
        }
    }
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) { }
}
// MARK: - collectionView 레이아웃 부분
private extension SearchPhotoViewController {
    func createImageLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.5))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(5)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 5
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    func createFilterLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.2), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(10)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 10
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: -170)
        
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}
// MARK: - DataSource 관련 코드
private extension SearchPhotoViewController {
    func upDateSnapshot(items: [ImageModel]) {
        var snapshot = Snapshot()
        snapshot.appendSections([DifferSection.image])
        snapshot.appendItems(items, toSection: .image)
        dataSource.apply(snapshot)
    }
    func upDateFilterSnapshot(_ colors: [ColorModel]) {
        var snapshot = FilterSnapshot()
        snapshot.appendSections([DifferSection.filterButton])
        snapshot.appendItems(colors)
        filterDateSource.apply(snapshot)
    }
    
    func setUpDataSource() {
        let using = phtoCellRegistration()
        dataSource = UICollectionViewDiffableDataSource(collectionView: imageCollectionView) { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: using, for: indexPath, item: itemIdentifier)
            return cell
        }
    }
    func setUpFilterDataSource() {
        let using = filterCellRegistration()
        filterDateSource = UICollectionViewDiffableDataSource(collectionView: filterCollectionView) { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: using, for: indexPath, item: itemIdentifier)
            return cell
        }
    }
    func phtoCellRegistration() -> Registration {
        let result = Registration { cell, indexPath, itemIdentifier in
            cell.updateUI(itemIdentifier.data, style: .search)
            cell.completion = { [weak self] in
                guard let self else { return }
                self.vm.inputLikeButton.value = itemIdentifier.data
                cell.toggleButton(self.vm.outputButtonToggle.value) //좋아요 색깔을 바꿀라면 여기서 color의 색을 전달받아서 쓰면될거 같음!
            }
        }
        return result
    }
    func filterCellRegistration() -> FilterRegistration {
        let result = FilterRegistration { cell, indexPath, itemIdentifier in
            cell.setUpButton(itemIdentifier)
            cell.completion = { [weak self] in
                guard let self else { return }
                self.vm.inputColorButtonTap.value = itemIdentifier
                print(itemIdentifier)
            }
        }
        return result
    }
}
// MARK: - 리로딩 뷰 관련 코드
private extension SearchPhotoViewController {
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
