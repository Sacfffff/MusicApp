//
//  SearchViewController.swift
//  MusicApp2
//
//  Created by Aleks Kravtsova on 13.06.22.
//

import UIKit
import SafariServices

class SearchViewController: UIViewController {
    
    private var viewModel : SearchViewModelProtocol = SearchViewModel()
  
    private let searchController : UISearchController = {
        let searchController = UISearchController(searchResultsController: SearchResultsViewController())
        searchController.searchBar.placeholder = "Songs, Artist, Albums"
        searchController.searchBar.searchBarStyle = .minimal
        searchController.definesPresentationContext = true
        return searchController
    }()
    
    private var collectionView : UICollectionView!{
        didSet {
            collectionView.dataSource = self
            collectionView.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        setupView()
        setupCollectionView()
        
       
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    private func setupView(){
     title = "Search"
        self.navigationController?.navigationBar.tintColor = .label
        self.navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .systemBackground
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        
        
    }
    

    //MARK: - setupCollectionView
    private func setupCollectionView(){
        let absoluteHeightDimension : CGFloat = 150.0
        let padding : CGFloat = 2.0
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { _, _ in
            //item
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)))
            
            item.contentInsets = NSDirectionalEdgeInsets(top: padding, leading: 7.0, bottom: padding, trailing: 7.0)
            //group
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(absoluteHeightDimension)),
                subitem: item,
                count: 2)
            
            group.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0)
            
            //section
            return NSCollectionLayoutSection(group: group)
        }))
        
        view.addSubview(collectionView)
        collectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: "\(CategoryCollectionViewCell.self)")
        collectionView.backgroundColor = .systemBackground
        viewModel.update = collectionView.reloadData
        viewModel.fetchDataForCategoriesSearch()
        
    }
    
    
}

//MARK: - extension UISearchResultsUpdating
extension SearchViewController : UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
    
}

//MARK: - extension UICollectionViewDataSource

extension SearchViewController : UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(CategoryCollectionViewCell.self)", for: indexPath) as? CategoryCollectionViewCell else {return .init() }
        let category = viewModel.categories[indexPath.row]
        cell.setup(with: CategoryCollectionViewCellViewModel(title: category.name, artworkURL: URL(string: category.icons.first?.url ?? " ")))
        return cell
    }
    
    
}

//MARK: - extension UICollectionViewDelegate

extension SearchViewController : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        HapticksManager.shared.vibrateForSelection()
        let category = viewModel.categories[indexPath.row]
        navigationController?.pushViewController(CategoryViewController(category: category), animated: true)
        
    }
}

//MARK: - extension UISearchBarDelegate

extension SearchViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let resultsController = searchController.searchResultsController as? SearchResultsViewController, let query = searchBar.text, !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        resultsController.delegate = self
        viewModel.setup = resultsController.configure(with:)
        viewModel.search(with: query)
    }
}

//MARK: - extension SearchResultsViewControllerDelegate
extension SearchViewController : SearchResultsViewControllerDelegate {
    func resultSectionDidTap(_ resultSection: SearchResult) {
        switch resultSection {
        case .artist(let model): 
            guard let url = URL(string: model.externalURLs["spotify"] ?? " ") else {return}
            let vc = SFSafariViewController(url: url)
            present(vc, animated: true)
        case .album(let model):
            navigationController?.pushViewController(AlbumViewController(album: model), animated: true)
        case .playlist(let model):
            navigationController?.pushViewController(PlaylistViewController(playlist: model), animated: true)
        case .track(let model):
            PlaybackPresenter.shared.startPlayBack(from: self, track: model)
        }
    }
}



