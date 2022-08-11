//
//  AlbumTrackListCollectionViewCell.swift
//  MusicApp2
//
//  Created by Aleks Kravtsova on 4.07.22.
//

import UIKit
import MarqueeLabel

class AlbumTrackListCollectionViewCell: UICollectionViewCell {
 
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
         
     }
     
     func setup(with model: AlbumTrackListViewModel){
         self.trackNameLabel.text = model.songName + " "
         self.artistNameLabel.text = model.artistName
     }
     
     
     private func setupConstraints(){
       
         NSLayoutConstraint.activate(
             [

                 //trackNameLabel
                trackNameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 5.0),
                trackNameLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10.0),
                trackNameLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 10.0),


                 //artistNameLabel
                 artistNameLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5.0),
                artistNameLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10.0),
                artistNameLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10.0)
  
         ])
    }
     
     
 }

