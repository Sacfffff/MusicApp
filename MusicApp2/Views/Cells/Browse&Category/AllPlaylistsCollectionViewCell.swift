//
//  RecommendedTrackCollectionViewCell.swift
//  MusicApp2
//
//  Created by Aleks Kravtsova on 27.06.22.
//

import UIKit

class AllPlaylistsCollectionViewCell : UICollectionViewCell {
    
    private let playlistCoverImageView : UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "photo"))
        imageView.tintColor = .gray
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 4
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let playlistNameLabel : UILabel = {
      let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let creatorNameLabel : UILabel = {
      let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .thin)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(playlistNameLabel)
        contentView.addSubview(creatorNameLabel)
        contentView.addSubview(playlistCoverImageView)
        contentView.clipsToBounds = true
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupConstraints()
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        playlistNameLabel.text = nil
        creatorNameLabel.text = nil
        playlistCoverImageView.image = nil
        
    }
    
    func setup(with model: AllPlaylistsCellViewModel){
            self.playlistNameLabel.text = model.name
        self.creatorNameLabel.text = model.creatorName
            self.playlistCoverImageView.sd_setImage(with: model.artworkURL)
    }
    
    
    private func setupConstraints(){
    
        NSLayoutConstraint.activate(
            [
                //playlistCoverImageView
                playlistCoverImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8.0),
                playlistCoverImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                playlistCoverImageView.widthAnchor.constraint(equalTo: self.heightAnchor, constant: -70),
                playlistCoverImageView.heightAnchor.constraint(equalTo: self.heightAnchor, constant: -70),
                
                //playlistNameLabel
                playlistNameLabel.topAnchor.constraint(equalTo: playlistCoverImageView.bottomAnchor, constant: 5.0),
                playlistNameLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                playlistNameLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 5.0),
                playlistNameLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -5.0),
                
                //creatorNameLabel
                creatorNameLabel.topAnchor.constraint(equalTo: playlistNameLabel.bottomAnchor, constant: 0.0),
                creatorNameLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
 
        ])
   }
    
}
