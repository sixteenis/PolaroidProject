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

enum SearchSection: CaseIterable {
    case firest
}
// TODO:  오류화면 만들기
// TODO: 필터버튼 구현
// TODO: 정렬 버튼 구현
// TODO: 다시 검색 시 맨앞으로 로딩해주기!
final class SearchPhotoViewController: BaseViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<SearchSection,ImageModel>
    typealias Snapshot = NSDiffableDataSourceSnapshot<SearchSection, ImageModel>
    typealias Registration = UICollectionView.CellRegistration<PhotoCollectionViewCell, ImageModel>
    
    
    private let loadingIndicator = UIActivityIndicatorView(style: .large)
    private let sortingButton = UIButton().then {
        $0.setTitle("정렬", for: .normal)
        $0.setTitleColor(.cBlack, for: .normal)
        $0.backgroundColor = .cWhite
    }
    private let line = UIView().then {
        $0.backgroundColor = .cGray
    }
    private let searchBar = UISearchBar().then {
        $0.placeholder = PlaceholderEnum.searchBar
        $0.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
    }
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    private var dataSource: DataSource!
    
    let vm = SearchPhotoViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpDataSource()

    }
    override func bindData() {
        vm.outputImageList.bind { data in
                
            self.upDateSnapshot(items: data)
        }
        vm.outputLoadingSet.bind(true) { bool in
            bool ? self.hideLoadingIndicator() : self.showLoadingIndicator()
        }
    }
    override func setUpHierarchy() {
        view.addSubview(searchBar)
        view.addSubview(line)
        view.addSubview(sortingButton)
        view.addSubview(collectionView)
        
        searchBar.delegate = self
        sortingButton.addTarget(self, action: #selector(sortingButtonTapped), for: .touchUpInside)
        collectionView.delegate = self
        collectionView.prefetchDataSource = self
        
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
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(sortingButton.snp.bottom).offset(10)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    override func setUpView() {
        navigationItem.title = "SEARCH PHOTO"
    }
    
}
// MARK: - 버튼 기능 부분
private extension SearchPhotoViewController {
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
extension SearchPhotoViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = dataSource.itemIdentifier(for: indexPath)
        let vc = DetailViewController()
        print(data!)
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
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
    }
}
// MARK: - collectionView 레이아웃 부분
private extension SearchPhotoViewController {
    func createLayout() -> UICollectionViewLayout {
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
    
}
// MARK: - DataSource 관련 코드
private extension SearchPhotoViewController {
    func upDateSnapshot(items: [ImageModel]) {
        var snapshot = Snapshot()
        snapshot.appendSections(SearchSection.allCases)
        snapshot.appendItems(items, toSection: .firest)
        dataSource.apply(snapshot)
    }
    func setUpDataSource() {
        let using = phtoCellRegistration()
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
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
