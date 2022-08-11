//
//  FeaturedPlaylistCollectionViewCell.swift
//  MusicApp2
//
//  Created by Aleks Kravtsova on 27.06.22.
//

import UIKit
import MarqueeLabel

class ListOfTrackCollectionViewCell: UICollectionViewCell {
    
    private let albumCoverImageView : UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "photo"))
        imageView.tintColor = .gray
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let trackNameLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let artistNameLabel : UILabel = {
      let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .thin)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubview(trackNameLabel)
        contentView.addSubview(artistNameLabel)
        contentView.addSubview(albumCoverImageView)
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
        trackNameLabel.text = nil
        artistNameLabel.text = nil
        albumCoverImageView.image = nil
        
    }
    
    func setup(with model: ListOfTrackCellViewModel){
        self.trackNameLabel.text = model.songName + " "
        self.artistNameLabel.text = model.artistName
            self.albumCoverImageView.sd_setImage(with: model.artworkURL)
    }
    
    
    private func setupConstraints(){
      
        NSLayoutConstraint.activate(
            [
                //albumCoverImageView
                albumCoverImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5.0),
                albumCoverImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 2.0),
                albumCoverImageView.widthAnchor.constraint(equalTo: contentView.heightAnchor, constant: -4.0),
                albumCoverImageView.rightAnchor.constraint(equalTo: trackNameLabel.rightAnchor, constant: -2.0),
                albumCoverImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, constant: -4.0),
                
                //trackNameLabel
                trackNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5.0),
                trackNameLabel.leftAnchor.constraint(equalTo: albumCoverImageView.rightAnchor, constant: 10.0),
                trackNameLabel.rightAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.rightAnchor, constant: -5.0),


                //artistNameLabel
                artistNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -3.0),
                artistNameLabel.leftAnchor.constraint(equalTo: albumCoverImageView.rightAnchor, constant: 10.0),
 
        ])
   }
    
    
}

