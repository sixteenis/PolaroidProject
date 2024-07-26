//
//  SearchPhotoView.swift
//  PolaroidProject
//
//  Created by 박성민 on 7/23/24.
//

import UIKit

import SnapKit
import Then
enum SearchSection: CaseIterable {
    case firest
}
final class SearchPhotoViewController: BaseViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<SearchSection,ImageDTO>
    typealias Snapshot = NSDiffableDataSourceSnapshot<SearchSection, ImageDTO>
    typealias Registration = UICollectionView.CellRegistration<PhotoCollectionViewCell, ImageDTO>
    
    
    
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

    }
    override func bindData() {
        vm.outputImageList.bind { data in
            self.setUpDataSource()
            self.upDateSnapshot(items: data)
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
        vm.inputStartNetworking.value = searchBar.text!
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
    func upDateSnapshot(items: [ImageDTO]) {
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
            cell.updateUI(itemIdentifier, style: .search)
        }
        return result
    }
}

