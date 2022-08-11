//
//  LibraryViewController.swift
//  MusicApp2
//
//  Created by Aleks Kravtsova on 13.06.22.
//

import UIKit

final class LibraryViewController: UIViewController {

    private let playlistVC = LibraryPlaylistsViewController()
    private let albumsVC = LibraryAlbumsViewController()
    
    private let scrollView : UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let libraryToggle : LibraryToggleView = {
        let libraryToggle = LibraryToggleView()
        libraryToggle.translatesAutoresizingMaskIntoConstraints = false
        return libraryToggle
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        setupView()
        updateBarButtons()
       
    }
    
    private func setupView(){
        title = "Library"
        view.backgroundColor = .secondarySystemBackground
        view.addSubview(scrollView)
        view.addSubview(libraryToggle)
        libraryToggle.delegate = self
        scrollView.delegate = self
        scrollView.contentSize = CGSize(width: view.width * 2, height: scrollView.height)
        addChildren()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupConstraints()
    }

    private func addChildren() {
        addChild(playlistVC)
        scrollView.addSubview(playlistVC.view)
        playlistVC.view.frame = CGRect(x: 0, y: 0, width: scrollView.width, height: scrollView.height)
        playlistVC.didMove(toParent: self)
        addChild(albumsVC)
        scrollView.addSubview(albumsVC.view)
        albumsVC.view.frame = CGRect(x: view.width, y: 0, width: scrollView.width, height: scrollView.height)
        albumsVC.didMove(toParent: self)
    }
    
    private func updateBarButtons(){
        switch libraryToggle.getCurrentState(){
        case .playlist:
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(plusButtonDidTap))
        case .album:
            navigationItem.rightBarButtonItem = nil
        }
    }
    
    @objc private func plusButtonDidTap(){
        playlistVC.showCreatePlaylistAlert()
    }
    
    private func setupConstraints(){
        
        NSLayoutConstraint.activate(
            [
                //scrollView
                scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 55.0),
                scrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
                scrollView.widthAnchor.constraint(equalTo: view.widthAnchor),
                scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
                
                //libraryToggle
                libraryToggle.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10.0),
                libraryToggle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                libraryToggle.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
                libraryToggle.bottomAnchor.constraint(equalTo: scrollView.topAnchor, constant: -10)
                
                
            ])
    }
    
}

//MARK: - extension UIScrollViewDelegate
extension LibraryViewController : UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x >= (view.width - 100){
            libraryToggle.update(for: .album)
            updateBarButtons()
        } else {
            libraryToggle.update(for: .playlist)
            updateBarButtons()
        }
    }
    
    
}


//MARK: - extension LibraryToggleViewDelegate
extension LibraryViewController : LibraryToggleViewDelegate {
    
    func didTapPlaylists(_ toggleView: LibraryToggleView) {
        scrollView.setContentOffset(.zero, animated: true)
        updateBarButtons()
    }
    
    func didTapAlbums(_ toggleView: LibraryToggleView) {
        scrollView.setContentOffset(CGPoint(x: view.width, y: 0), animated: true)
        updateBarButtons()
    }
    
    
}
