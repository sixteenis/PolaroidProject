//
//  SearchPhotoView.swift
//  PolaroidProject
//
//  Created by 박성민 on 7/23/24.
//

import UIKit

import SnapKit
import Then
import Toast


// MARK: - 먼가 좋아요 갱신이 되면서도 안됨... 네트워킹 완료전에 다시 화면으로 들오면 적용이 안되는 듯....
// TODO: - 좋아요를 눌르면 램에 저장되고 램에서 파일매니저에 저장하는 과정에서 딜레이가 있음.. 그 딜레이 때문에 좋아요가 늦게 적용되거나 반영이 안되는 경우가 생김... 나중에 수정하자.. 꼭!!!

// MARK: - 좋아요 갱신이 될때도 있구... 안될때두 있습니당...
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
        $0.setImage(UIImage(named: "sort"), for: .normal)
        $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        $0.backgroundColor = .cWhite
        $0.layer.masksToBounds = true
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.cGray.cgColor
        $0.layer.cornerRadius = 15
    }
    private let line = UIView().then {
        $0.backgroundColor = .cGray
    }
    private let searchBar = UISearchBar().then {
        $0.placeholder = PlaceholderEnum.searchBar
        $0.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
    }
    private var settingLabel = UILabel().then {
        $0.textColor = .cBlack
        $0.textAlignment = .center
        $0.isHidden = false
    }
    
    let vm = SearchPhotoViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.vm.inputViewDidLoad.value = ()
    }
    // MARK: - view가 뜨기전 뜨기직전에 둘다 저장된 값을 체크하는게 맞나...? 일단 작동은 하니 나중에 수정하자.!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "SEARCH PHOTO"
        self.vm.inputViewWillAppear.value = ()
    }
    override func bindData() {
        vm.outputSetTitle.bind(true) { title in
            self.settingLabel.isHidden = false
            self.imageCollectionView.isHidden = true
            self.settingLabel.text = title
        }
        
        vm.outputLoadingSet.bind(true) { bool in
            bool ? self.hideLoadingIndicator() : self.showLoadingIndicator()
        }
        //통신을 통해 얻은 데이터
        vm.outputImageList.bind(true) { data in
            self.settingLabel.isHidden = true
            self.imageCollectionView.isHidden = false
            self.setUpDataSource()
            self.upDateSnapshot(items: data)
        }
        //이미 가지고 있는 데이터
        vm.outputSaveImageList.bind(true) { data in
            self.settingLabel.isHidden = true
            self.imageCollectionView.isHidden = false
            self.setUpDataSource()
            self.upDateSnapshot(items: data)
        }
        vm.outputOrderby.bind(true) { type in
            self.sortingButton.setTitle(" \(type.title) ", for: .normal)
        }
        vm.outputScrollingTop.bind { _ in
            self.imageCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
        }
        vm.outputColors.bind { colors in
            self.setUpFilterDataSource()
            self.upDateFilterSnapshot(colors)
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
    //    @objc func navrightButtonTapped() {
    //        let vc = LoginViewController()
    //        vc.vm.settingType = .setting
    //        navigationController?.pushViewController(vc, animated: true)
    //    }
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
        // TODO: imageColletion일때만 작동하게 ㅇㅇ
        if indexPaths[0].item == vm.outputImageList.value.count - 4 {
            vm.inputPage.value = indexPaths[0].item
        }
    }
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
    }
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
    // MARK: - 여기부터 진행시켜!
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
    func upDateFilterSnapshot(_ colors: [ColorModel]) {//items: [SearchColor] _ item: [SearchColor]
        var snapshot = FilterSnapshot()
        snapshot.appendSections([DifferSection.filterButton])
        snapshot.appendItems(colors)
        //모든 컬러 안에 먼가를 비교할 그거를...
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
            cell.completion = {
                self.vm.inputLikeButton.value = itemIdentifier.data
                cell.toggleButton(self.vm.outputButtonToggle.value)
            }
            
        }
        return result
    }
    func filterCellRegistration() -> FilterRegistration {
        let result = FilterRegistration { cell, indexPath, itemIdentifier in
            cell.setUpButton(itemIdentifier)
            cell.completion = {
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
