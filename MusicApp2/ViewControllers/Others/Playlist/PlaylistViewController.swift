//
//  PlaylistViewController.swift
//  MusicApp2
//
//  Created by Aleks Kravtsova on 13.06.22.
//

import UIKit

final class PlaylistViewController: UIViewController {
    
    private var viewModel : PlaylistViewModelProtocol
    
    private enum ConstForExternalUrls {
        static let spotify = "spotify"
    }
    
    private var collectionView : UICollectionView! {
        didSet{
            collectionView.delegate = self
            collectionView.dataSource = self
        }
    }
    
    init(playlist: Playlist){
        viewModel = PlaylistViewModel(playlist: playlist)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupCollectionView()
        setupShareButton()

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    func isOwner(value: Bool){
        viewModel.isOwner = value
    }
    
    private func setupView(){
        title = viewModel.playlist.name
        self.navigationItem.largeTitleDisplayMode = .never
        view.backgroundColor = .systemBackground

    }
  
   // MARK: - setupCollectionView()
    private func setupCollectionView(){
        collectionView = UICollectionView(frame: .zero,
                                          collectionViewLayout: UICollectionViewCompositionalLayout { [weak self] _, _ in
            self?.createSectionLayout()
        })
        view.addSubview(collectionView)
        collectionView.backgroundColor = .systemBackground
        collectionView.register(HeaderWithImageCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "\(HeaderWithImageCollectionReusableView.self)")
        collectionView.register(ListOfTrackCollectionViewCell.self, forCellWithReuseIdentifier: "\(ListOfTrackCollectionViewCell.self)")
      updateUI()
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(didLongPress(_:)))
        collectionView.addGestureRecognizer(gesture)

    }
    
    private func updateUI(){
        viewModel.update = collectionView.reloadData
        viewModel.fetchData()
    }
  //MARK: - Setup share button
    private func setupShareButton(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareButtonDidTap))
    }
    
    @objc private func shareButtonDidTap(){
        guard let url = URL(string: viewModel.playlist.externalURLs[ConstForExternalUrls.spotify] ?? " ") else {
            return
        }
        let activityVC = UIActivityViewController(activityItems: [url],
                                                  applicationActivities: [])
        activityVC.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(activityVC, animated: true)
    }
    
    //MARK: - didLongPress
    @objc private func didLongPress(_ gesture: UILongPressGestureRecognizer){
        guard gesture.state == .began else {return}
        let touchPoint = gesture.location(in: collectionView)
        guard let indexPath = collectionView.indexPathForItem(at: touchPoint) else {
            return
        }
        let track = viewModel.tracks[indexPath.row]
        if viewModel.isOwner {
            showRemoveAlert(with: track, index: indexPath)
        } else {
            viewModel.addTrack(track: track, self)
        }
       
        
    }
    
    //MARK: - showRemoveAlert
    private func showRemoveAlert(with track: AudioTrack, index : IndexPath){
        
        let actionSheet = UIAlertController(title: track.name, message: "Woud you like to remove this from the playlist?", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        actionSheet.addAction(UIAlertAction(title: "Remove", style: .destructive, handler: { [weak self] _ in
            guard let strongSelf = self else {return}
            
            
            strongSelf.viewModel.update = {
                HapticksManager.shared.vibrate(for: .success)
                strongSelf.updateUI()

            }
            strongSelf.viewModel.removeTrack(track: track, from: strongSelf.viewModel.playlist, by: index.row)
    
        }))
        present(actionSheet, animated: true)
    }
    

    
    
}

// MARK: - UICollectionViewDelegate
extension PlaylistViewController : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let track = viewModel.tracks[indexPath.row]
        PlaybackPresenter.shared.startPlayBack(from: self, track: track)
    }
}

// MARK: - UICollectionViewDataSource
extension PlaylistViewController : UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.listOfTrackModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(ListOfTrackCollectionViewCell.self)", for: indexPath) as? ListOfTrackCollectionViewCell
        cell?.setup(with: viewModel.listOfTrackModels[indexPath.row])
        return cell ?? .init()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader, let header  = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "\(HeaderWithImageCollectionReusableView.self)", for: indexPath) as? HeaderWithImageCollectionReusableView else {
            return .init()
        }
       
        let headerViewModel = HeaderWithImageVViewModel(name: viewModel.playlist.name,
                                                        ownerName: viewModel.playlist.owner.displayName,
                                                        description: viewModel.playlist.description,
                                                        artworkURL: URL(string: viewModel.playlist.images?.first?.url ?? " "))
        header.setup(with: headerViewModel)
        header.delegate = self
      return header
    }
    
    func collectionView(_ collectionView: UICollectionView, canEditItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    
}

// MARK: - extension for section layout

extension PlaylistViewController {
    
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

extension PlaylistViewController : HeaderWithImageCollectionReusableViewDelegate {
   
    func playHeaderCollectionReusableViewDidTapPlayAll(_ header: HeaderWithImageCollectionReusableView) {
        PlaybackPresenter.shared.startPlayBack(from: self, tracks: viewModel.tracks)
    }
    
    
}
