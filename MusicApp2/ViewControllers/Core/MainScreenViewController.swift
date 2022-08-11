//
//  MainScreenViewController.swift
//  MusicApp2
//
//  Created by Aleks Kravtsova on 13.06.22.
//

import UIKit



final class MainScreenViewController : UIViewController {
    
    private var viewModel : MainViewModelProtocol = MainViewModel()
    
    private var collectionView : UICollectionView! {
        didSet {
            collectionView.dataSource = self
            collectionView.delegate = self
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        setupCollectionView()
        setupView()
        addLongTypeGesture()

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    

    private func setupView() {
        title = "Browse"
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"),
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(didTapSettings))
        viewModel.update = collectionView.reloadData
        viewModel.fetchData()
    
}
    
    
    // MARK: - setupCollectionView()
    private func setupCollectionView(){
          collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: UICollectionViewCompositionalLayout {[weak self] sectionIndex, _ in
            self?.createSectionLayout(section: sectionIndex)
        })
        view.addSubview(collectionView)
        collectionView.register(NewReleasesCollectionViewCell.self, forCellWithReuseIdentifier: "\(NewReleasesCollectionViewCell.self)")
        collectionView.register(AllPlaylistsCollectionViewCell.self, forCellWithReuseIdentifier: "\(AllPlaylistsCollectionViewCell.self)")
        collectionView.register(TitleHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "\(TitleHeaderCollectionReusableView.self)")
        collectionView.register(ListOfTrackCollectionViewCell.self, forCellWithReuseIdentifier: "\(ListOfTrackCollectionViewCell.self)")
        collectionView.backgroundColor = .systemBackground
        collectionView.showsVerticalScrollIndicator = false
    }
    
    private func createSectionLayout(section: Int) -> NSCollectionLayoutSection {
        switch section {
        case 0:
            return createSectionsForNewReleases()
        case 1:
            return createSectionsForFeaturedPlaylist()
        case 2:
            return createSectionsForRecommendedTracks()
        default:
            return createSectionsForDefault()
        }
    }
   
    //MARK: - add Long gesture
    private func addLongTypeGesture() {
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(didLongPress(_:)))
        collectionView.addGestureRecognizer(gesture)
    }
    
    @objc private func didTapSettings(){
        let settingsVC = SettingsViewController()
        navigationController?.pushViewController(settingsVC, animated: true)
    }
    
    @objc private func didLongPress(_ gesture: UILongPressGestureRecognizer){
        guard gesture.state == .began else {return}
        let touchPoint = gesture.location(in: collectionView)
        guard let indexPath = collectionView.indexPathForItem(at: touchPoint), indexPath.section == 2 else {return}
        viewModel.addTrack(track: viewModel.tracks[indexPath.row], self)

    }
    
    
    //MARK: - OpenInfo methods
    
    private func openSpecificAlbumVC(by indexPath: IndexPath){
        navigationController?.pushViewController(AlbumViewController(album: viewModel.albums[indexPath.row]), animated: true)
    }
    
    private func openSpecificPlaylistVC(by indexPath: IndexPath){
        navigationController?.pushViewController(PlaylistViewController(playlist: viewModel.playlists[indexPath.row]), animated: true)
    }
    
    
}


// MARK: - UICollectionViewDataSource
extension MainScreenViewController : UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let type = viewModel.sections[section]
        switch type {
        case .newReleases(let viewModels):
            return viewModels.count
        case .featuredPlaylist(let viewModels):
           return viewModels.count
        case .recommendedTracks(let viewModels):
           return viewModels.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let type = viewModel.sections[indexPath.section]
        
        switch type {
            
        case .newReleases(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(NewReleasesCollectionViewCell.self)", for: indexPath) as? NewReleasesCollectionViewCell else {return .init()}
            cell.setup(with: viewModels[indexPath.row])
            
            return cell
        case .featuredPlaylist(let viewModels):
            guard let cell =
                    collectionView.dequeueReusableCell(withReuseIdentifier: "\(AllPlaylistsCollectionViewCell.self)", for: indexPath) as? AllPlaylistsCollectionViewCell else {return .init()}
            cell.setup(with: viewModels[indexPath.row])
            return cell
         
        case .recommendedTracks(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(ListOfTrackCollectionViewCell.self)", for: indexPath) as? ListOfTrackCollectionViewCell else {return .init()}
            cell.setup(with: viewModels[indexPath.row])
            return cell
          
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader, let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "\(TitleHeaderCollectionReusableView.self)", for: indexPath) as? TitleHeaderCollectionReusableView else { return .init() }
        let section = indexPath.section
        let modelTitle =  viewModel.sections[section].title
        header.setup(with: modelTitle)
        
        return header
    }
    
    
    
}

// MARK: - UICollectionViewDelegate
extension MainScreenViewController : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        HapticksManager.shared.vibrateForSelection()
        let section =  viewModel.sections[indexPath.section]
        switch section {
        case .featuredPlaylist:
            openSpecificPlaylistVC(by: indexPath)
        case .newReleases:
            openSpecificAlbumVC(by: indexPath)
        case .recommendedTracks:
            let track = viewModel.tracks[indexPath.row]
            PlaybackPresenter.shared.startPlayBack(from: self, track: track)
        }
    }
    
}


// MARK: - Extension for creating different sections
extension MainScreenViewController {
    
    private var supplementaryViews : [NSCollectionLayoutBoundarySupplementaryItem] {
        return   [
            NSCollectionLayoutBoundarySupplementaryItem(layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(50.0)),
                                                        elementKind: UICollectionView.elementKindSectionHeader,
                                                        alignment: .top)
        ]
    }

        private func createSectionsForNewReleases() -> NSCollectionLayoutSection{
            let generalFractionalWidthAndHeight : CGFloat = 1.0
            let heightDimensionAbsolute : CGFloat = 390.0
            let countOfItems = 3
            let padding : CGFloat =  2
            //item
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(generalFractionalWidthAndHeight),
                heightDimension: .fractionalWidth(generalFractionalWidthAndHeight)))
            
            item.contentInsets = NSDirectionalEdgeInsets(top: padding, leading: padding, bottom: padding, trailing: padding)
            //group
            let verticalGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(generalFractionalWidthAndHeight),
                heightDimension: .absolute(heightDimensionAbsolute)),
                subitem: item,
                count: countOfItems)
            
            let horizontalGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(generalFractionalWidthAndHeight - 0.1),
                heightDimension: .absolute(heightDimensionAbsolute)),
                subitem: verticalGroup,
                count: 1)
            //section
            let section =  NSCollectionLayoutSection(group: horizontalGroup)
            section.orthogonalScrollingBehavior = .groupPaging
            section.boundarySupplementaryItems = supplementaryViews
            return section
        }
        
        private func createSectionsForDefault() -> NSCollectionLayoutSection{
            let generalFractionalWidthAndHeight : CGFloat = 1.0
            let heightDimensionAbsolute : CGFloat = 390.0
            let countOfItems = 1
            let padding : CGFloat =  2
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(generalFractionalWidthAndHeight),
                heightDimension: .fractionalWidth(generalFractionalWidthAndHeight)))
            
            item.contentInsets = NSDirectionalEdgeInsets(top: padding, leading: padding, bottom: padding, trailing: padding)
            let group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(generalFractionalWidthAndHeight),
                heightDimension: .absolute(heightDimensionAbsolute)),
                subitem: item,
                count: countOfItems)
            let section =  NSCollectionLayoutSection(group: group)
            section.boundarySupplementaryItems = supplementaryViews
            return section
        }
        
        private func createSectionsForFeaturedPlaylist() -> NSCollectionLayoutSection {
            let heightAndWidthDimensionAbsolute : CGFloat = 200.0
            let countOfItems = 1
            let padding : CGFloat =  2
            //item
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
                widthDimension: .absolute(heightAndWidthDimensionAbsolute),
                heightDimension: .absolute(heightAndWidthDimensionAbsolute)))
            
            item.contentInsets = NSDirectionalEdgeInsets(top: padding, leading: padding, bottom: padding, trailing: padding)
            //group
            let verticalGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(
                widthDimension: .absolute(heightAndWidthDimensionAbsolute),
                heightDimension: .absolute(heightAndWidthDimensionAbsolute * 2)),
                subitem: item,
                count: countOfItems + 1)
            
            let horizontalGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(
                widthDimension: .absolute(heightAndWidthDimensionAbsolute),
                heightDimension: .absolute(heightAndWidthDimensionAbsolute * 2)),
                subitem: verticalGroup,
                count: countOfItems)
            //section
            let section =  NSCollectionLayoutSection(group: horizontalGroup)
            section.orthogonalScrollingBehavior = .continuous
            section.boundarySupplementaryItems = supplementaryViews
            return section
        }
        
        private func createSectionsForRecommendedTracks() -> NSCollectionLayoutSection {
            let generalFractionalWidthAndHeight : CGFloat = 1.0
            let heightAbsolute : CGFloat = 80.0
            let countOfItems = 1
            let padding : CGFloat =  2
            //item
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(generalFractionalWidthAndHeight),
                heightDimension: .fractionalHeight(generalFractionalWidthAndHeight)))
            
            
            item.contentInsets = NSDirectionalEdgeInsets(top: padding, leading: padding, bottom: padding, trailing: padding)
            //group
            
            let group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(generalFractionalWidthAndHeight),
                heightDimension: .absolute(heightAbsolute)),
                subitem: item,
                count: countOfItems)
            //section
            let section =  NSCollectionLayoutSection(group: group)
            section.boundarySupplementaryItems = supplementaryViews
            return section
        }
}
