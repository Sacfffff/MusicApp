//
//  LibraryToggleView.swift
//  MusicApp2
//
//  Created by Aleks Kravtsova on 15.07.22.
//

import UIKit

protocol LibraryToggleViewDelegate : AnyObject {
    func didTapPlaylists(_ toggleView: LibraryToggleView)
    func didTapAlbums(_ toggleView: LibraryToggleView)
}

class LibraryToggleView: UIView {
    
  
    weak var delegate : LibraryToggleViewDelegate?
    
    private let viewModel : LibraryToggleViewViewModel = LibraryToggleViewViewModel()
    
    private let playlistsButton : UIButton = {
        let button = UIButton()
        button.setTitleColor(.label, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Playlists", for: .normal)
        return button
    }()

    private let albumsButton : UIButton = {
        let button = UIButton()
        button.setTitleColor(.label, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Albums", for: .normal)
        return button
    }()
    
    private let indicatorView : UIView = {
        let view = UIView()
        view.backgroundColor = .systemGreen
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 4
        return view
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(playlistsButton)
        addSubview(albumsButton)
        addSubview(indicatorView)
        playlistsButton.addTarget(self, action: #selector(playlistsButtonDidTap), for: .touchUpInside)
        albumsButton.addTarget(self, action: #selector(albumsButtonDidTap), for: .touchUpInside)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupConstraints()

    }
    
    func update(for state: LibraryToggleViewViewModel.State){
        viewModel.state = state
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.layoutIndicator()
        }
    }
        
    func getCurrentState() -> LibraryToggleViewViewModel.State {
        return viewModel.state
    }
    
    @objc private func playlistsButtonDidTap(){
        update(for: .playlist)
        delegate?.didTapPlaylists(self)
    }
    
    @objc private func albumsButtonDidTap(){
        update(for: .album)
        delegate?.didTapAlbums(self)
    }
    
    private func setupConstraints(){
        
      
        
        NSLayoutConstraint.activate(
            [
                //playlistsButton
                playlistsButton.topAnchor.constraint(equalTo: self.topAnchor),
                playlistsButton.leftAnchor.constraint(equalTo: self.leftAnchor),
                playlistsButton.widthAnchor.constraint(equalToConstant: 100.0),
                playlistsButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5.0),
                
                //albumsButton
                albumsButton.topAnchor.constraint(equalTo: self.topAnchor),
                albumsButton.leftAnchor.constraint(equalTo: playlistsButton.rightAnchor, constant: 10.0),
                albumsButton.widthAnchor.constraint(equalToConstant: 100.0),
                albumsButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5.0),
                
                
                
            ])
        
        layoutIndicator()
        

}
    
    private func layoutIndicator(){
        switch viewModel.state {
        case .album:
            indicatorView.frame = CGRect(x: playlistsButton.width + 10, y: albumsButton.bottom, width: albumsButton.width, height: 1.0)
        case .playlist:
            indicatorView.frame = CGRect(x: 0, y: playlistsButton.bottom, width: playlistsButton.width, height: 1.0)
        }
    }
}
