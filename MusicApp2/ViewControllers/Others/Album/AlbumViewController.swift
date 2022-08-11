//
//  AlbumViewController.swift
//  MusicApp2
//
//  Created by Aleks Kravtsova on 2.07.22.
//

import UIKit

final class AlbumViewController: UIViewController {
    
    private var viewModel : AlbumViewModelProtocol

    private enum ConstForExternalUrls {
        static let spotify = "spotify"
    }

    private var collectionView : UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
        }
    }
    
    init(album: Album){
        viewModel = AlbumViewModel(album: album)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       setupView()
        setupCollectionView()
        addLongTypeGesture()
        
   
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    private func setupView(){
        title = viewModel.album.name
        self.navigationItem.largeTitleDisplayMode = .never
        view.backgroundColor = .systemBackground
        setupBarButtons()
        
  
        
        
    }
    
    // MARK: - setupCollectionView
    private func setupCollectionView(){
        collectionView = UICollectionView(frame: .zero,
                                          collectionViewLayout: UICollectionViewCompositionalLayout { [weak self] _, _ in
            self?.createSectionLayout()
        })
        view.addSubview(collectionView)
        collectionView.backgroundColor = .systemBackground
        collectionView.register(HeaderWithImageCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "\(HeaderWithImageCollectionReusableView.self)")
        collectionView.register(AlbumTrackListCollectionViewCell.self, forCellWithReuseIdentifier: "\(AlbumTrackListCollectionViewCell.self)")
        viewModel.update = collectionView.reloadData
        viewModel.fetchData()
        
 
    }
    
    
    // MARK: - setupBarButtons
    private func setupBarButtons(){
        viewModel.isExistCurrentAlbumInCollection(album: viewModel.album, completion: { [weak self] success in
            if success {
                self?.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(self?.deleteButtomDidTap))
            } else {
                self?.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(self?.actionButtomDidTap))
            }
        })
        
    }
    
    
    // MARK: - addLongTypeGesture
    private func addLongTypeGesture() {
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(didLongPress(_:)))
        collectionView.addGestureRecognizer(gesture)
    }
    
  
    
    
    @objc private func didLongPress(_ gesture: UILongPressGestureRecognizer){
        guard gesture.state == .began else {return}
        let touchPoint = gesture.location(in: collectionView)
        guard let indexPath = collectionView.indexPathForItem(at: touchPoint) else {
            return
        }
        viewModel.addTrack(track: viewModel.tracks[indexPath.row], self)
      
        
    }
    // MARK: - actions for buttons
    
    @objc private func actionButtomDidTap(){
        let actionSheet = UIAlertController(title: viewModel.album.name, message: "Actions", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        actionSheet.addAction(UIAlertAction(title: "Save album", style: .default, handler: { [weak self] _ in
                guard let strongSelf = self else {return}
                strongSelf.viewModel.update = {
                    HapticksManager.shared.vibrate(for: .success)
                    self?.setupBarButtons()
                    NotificationCenter.default.post(name: .albumChangedNotification, object: nil)
                   
                }
                strongSelf.viewModel.failure = {
                    HapticksManager.shared.vibrate(for: .warning)
                    strongSelf.alert(title: "Failure", message: "Something went wrong. Please try again later", preferredStyle: .alert)
                }
                
                strongSelf.viewModel.saveAlbum(album: strongSelf.viewModel.album)
            
          
        }))
        
        present(actionSheet, animated: true)
    }
    
    @objc private func deleteButtomDidTap(){
        let actionSheet = UIAlertController(title: viewModel.album.name, message: "Actions", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        actionSheet.addAction(UIAlertAction(title: "Delete album", style: .default, handler: { [weak self] _ in
                guard let strongSelf = self else {return}
                strongSelf.viewModel.update = {
                    HapticksManager.shared.vibrate(for: .success)
                    self?.setupBarButtons()
                    NotificationCenter.default.post(name: .albumChangedNotification, object: nil)
                }
                strongSelf.viewModel.failure = {
                    HapticksManager.shared.vibrate(for: .warning)
                    strongSelf.alert(title: "Failure", message: "Something went wrong. Please try again later", preferredStyle: .alert)
                }
                
            strongSelf.viewModel.deleteAlbum(album: strongSelf.viewModel.album)
            
          
        }))
        
        present(actionSheet, animated: true)
    }


    
    private func alert(title: String?, message: String?, preferredStyle: UIAlertController.Style){
        DispatchQueue.main.async { [weak self] in
            let alert =  UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            self?.present(alert, animated: true)
        }
       
    }
    
}

// MARK: - UICollectionViewDelegate
extension AlbumViewController : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        var track = viewModel.tracks[indexPath.row]
        track.album = viewModel.album
        PlaybackPresenter.shared.startPlayBack(from: self, track: track)
    }
}

// MARK: - UICollectionViewDataSource
extension AlbumViewController : UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.albumTrackListModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(AlbumTrackListCollectionViewCell.self)", for: indexPath) as? AlbumTrackListCollectionViewCell
        cell?.setup(with: viewModel.albumTrackListModels[indexPath.row])
        return cell ?? .init()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader, let header  = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "\(HeaderWithImageCollectionReusableView.self)", for: indexPath) as? HeaderWithImageCollectionReusableView else {
            return .init()
        }

        let headerViewModel = HeaderWithImageVViewModel(name: viewModel.album.name,
                                                        ownerName: viewModel.album.artists.first?.name ?? "-",
                                                        description: "Release date: \(String.formattedDate(string: viewModel.album.releaseDate))",
                                                        artworkURL: URL(string: viewModel.album.images.first?.url ?? " "))
        header.setup(with: headerViewModel)
        header.delegate = self
      return header
    }
    
}


// MARK: - extension for HeaderWithImageCollectionReusableViewDelegate
extension AlbumViewController : HeaderWithImageCollectionReusableViewDelegate {
    
    func playHeaderCollectionReusableViewDidTapPlayAll(_ header: HeaderWithImageCollectionReusableView) {
        let tracksWithAlbum : [AudioTrack] = viewModel.tracks.compactMap({
            var track = $0
            track.album = self.viewModel.album
            return track
        })
       
            PlaybackPresenter.shared.startPlayBack(from: self, tracks: tracksWithAlbum)
        
       
    }

}


// MARK: - extension for section layout

extension AlbumViewController {
    
    private func createSectionLayout() -> NSCollectionLayoutSection {
        let generalFractionalWidthAndHeight : CGFloat = 1.0
        let heightAbsolute : CGFloat = 60.0
        let countOfItems = 1
        let padding : CGFloat =  2
        //item
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(generalFractionalWidthAndHeight),
            heightDimension: .fractionalHeight(generalFractionalWidthAndHeight)))
        
        
        item.contentInsets = NSDirectionalEdgeInsets(top: padding - 1, leading: padding, bottom: padding - 1, trailing: padding)
        //group
        
        let group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(generalFractionalWidthAndHeight),
            heightDimension: .absolute(heightAbsolute)),
            subitem: item,
            count: countOfItems)
        //section
        let section =  NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems =
        [
            NSCollectionLayoutBoundarySupplementaryItem(layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(generalFractionalWidthAndHeight),
                heightDimension: .fractionalWidth(generalFractionalWidthAndHeight)),
                                                        elementKind: UICollectionView.elementKindSectionHeader,
                                                        alignment: .top)
        ]
        
        return section
    }
}






