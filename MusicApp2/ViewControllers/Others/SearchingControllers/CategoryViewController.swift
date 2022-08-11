//
//  CategoryViewController.swift
//  MusicApp2
//
//  Created by Aleks Kravtsova on 8.07.22.
//

import UIKit

class CategoryViewController: UIViewController {

    private var viewModel : CategoryViewModelProtocol
    
    private var collectionView : UICollectionView! {
        didSet{
            collectionView.delegate = self
            collectionView.dataSource = self
        }
    }
    
    init(category: Category){
        viewModel = CategoryViewModel(category: category)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupCollectionView()
      
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    private func setupView(){
        title = viewModel.category.name
        view.backgroundColor = .systemBackground
        navigationItem.largeTitleDisplayMode = .never
    }
    
    private func setupCollectionView(){
        let fractionalWidthHeight : CGFloat = 1.0
        let groupHeightAbsolute : CGFloat = 250.0
        let padding : CGFloat = 5.0
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout(
            sectionProvider: { _, _ in
                let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(fractionalWidthHeight),
                    heightDimension: .fractionalHeight(fractionalWidthHeight)))
                
                item.contentInsets = NSDirectionalEdgeInsets(top: padding, leading: padding, bottom: padding, trailing: padding)
                
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(fractionalWidthHeight),
                    heightDimension: .absolute(groupHeightAbsolute)),
                                                               subitem: item,
                                                               count: 2)
                group.contentInsets = NSDirectionalEdgeInsets(top: padding, leading: padding, bottom: padding, trailing: padding)
                
                return NSCollectionLayoutSection(group: group)
                
                
            }))
        collectionView.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        collectionView.register(AllPlaylistsCollectionViewCell.self, forCellWithReuseIdentifier: "\(AllPlaylistsCollectionViewCell.self)")
        viewModel.update = collectionView.reloadData
        viewModel.fetchData()
        
    }
}


//MARK: - extension UICollectionViewDataSource

extension CategoryViewController : UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.playlists.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(AllPlaylistsCollectionViewCell.self)", for: indexPath) as? AllPlaylistsCollectionViewCell else {return .init() }
        let playlist = viewModel.playlists[indexPath.row]
        cell.setup(with: AllPlaylistsCellViewModel(name: playlist.name,
                                                   artworkURL: URL(string: playlist.images?.first?.url ?? " "),
                                                   creatorName: playlist.owner.displayName))
        return cell
    }
    
    
}

//MARK: - extension UICollectionViewDelegate

extension CategoryViewController : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        navigationController?.pushViewController(PlaylistViewController(playlist: viewModel.playlists[indexPath.row]), animated: true)
    }
}

