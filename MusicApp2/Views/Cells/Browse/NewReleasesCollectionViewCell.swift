//
//  NewReleasesCollectionViewCell.swift
//  MusicApp2
//
//  Created by Aleks Kravtsova on 27.06.22.
//

import UIKit
import SDWebImage

class NewReleasesCollectionViewCell: UICollectionViewCell {
   
    private let albumCoverImageView : UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "photo"))
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = .gray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let albumNameLabel : UILabel = {
      let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let numberOfTracksLabel : UILabel = {
      let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .thin)
        label.textColor = .systemGray
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let artistNameLabel : UILabel = {
      let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .light)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubview(albumNameLabel)
        contentView.addSubview(artistNameLabel)
        contentView.addSubview(albumCoverImageView)
        contentView.addSubview(numberOfTracksLabel)
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
        albumNameLabel.text = nil
        artistNameLabel.text = nil
        numberOfTracksLabel.text = nil
        albumCoverImageView.image = nil
        
    }
    
    func setup(with model: NewReleasesCellViewModel){
            self.albumNameLabel.text = model.name
            self.artistNameLabel.text = model.arttistName
            self.numberOfTracksLabel.text = "Tracks: \(model.numberOfTracks)"
            self.albumCoverImageView.sd_setImage(with: model.artworkURL)
    }
    
    
    private func setupConstraints(){

        NSLayoutConstraint.activate(
            [
                //albumCoverImageView
                albumCoverImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5.0),
                albumCoverImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 5.0),
                albumCoverImageView.widthAnchor.constraint(equalTo: contentView.heightAnchor, constant: -10.0),
                albumCoverImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, constant: -10),
                
                //albumNameLabel
                albumNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5.0),
                albumNameLabel.leftAnchor.constraint(equalTo: albumCoverImageView.rightAnchor, constant: 10.0),
                albumNameLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -5.0),
                
                //artistNameLabel
                artistNameLabel.topAnchor.constraint(equalTo: albumNameLabel.bottomAnchor, constant: 0.0),
                artistNameLabel.leftAnchor.constraint(equalTo: albumCoverImageView.rightAnchor, constant: 10.0),
                artistNameLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -5.0),
                
                //numberOfTracksLabel
                numberOfTracksLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5.0),
                numberOfTracksLabel.leftAnchor.constraint(equalTo: albumCoverImageView.rightAnchor, constant: 10.0),
 
        ])
   }
    
    
}
