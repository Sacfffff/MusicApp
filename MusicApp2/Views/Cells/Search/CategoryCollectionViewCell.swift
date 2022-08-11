//
//  GenreCollectionViewCell.swift
//  MusicApp2
//
//  Created by Aleks Kravtsova on 6.07.22.
//

import UIKit
import SDWebImage

class CategoryCollectionViewCell: UICollectionViewCell {
    
    private let imageView : UIImageView = {
        let image = UIImage(systemName: "music.quarternote.3", withConfiguration: UIImage.SymbolConfiguration(pointSize: 50.0, weight: .regular))
        let imageView = UIImageView(image: image)
        imageView.tintColor = .white
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let genreNameLabel : UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
        addSubview(imageView)
        addSubview(genreNameLabel)
        
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
        genreNameLabel.text = nil
        imageView.image =  UIImage(systemName: "music.quarternote.3", withConfiguration: UIImage.SymbolConfiguration(pointSize: 50.0, weight: .regular))
        
    }
    
    func setup(with model: CategoryCollectionViewCellViewModel){
        genreNameLabel.text = model.title
        imageView.sd_setImage(with: model.artworkURL)
    }
    
    private func setupConstraints(){
        
        NSLayoutConstraint.activate(
            [
                
                //genreNameLabel
                genreNameLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10.0),
                genreNameLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 5.0),
                genreNameLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10.0),
                
                
                //imageView
                imageView.topAnchor.constraint(equalTo: self.topAnchor),
                imageView.rightAnchor.constraint(equalTo: self.rightAnchor),
                imageView.leftAnchor.constraint(equalTo: self.leftAnchor),
                imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
                
                
            ])
    }
}
