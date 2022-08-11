//
//  SearchResultsDefaultTableViewCell.swift
//  MusicApp2
//
//  Created by Aleks Kravtsova on 10.07.22.
//

import SDWebImage
import UIKit

class SearchResultDefaultTableViewCell: UITableViewCell {
    
    private let nameLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let iconImageView : UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "photo"))
        imageView.tintColor = .gray
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(nameLabel)
        addSubview(iconImageView)
        contentView.clipsToBounds = true
        accessoryType = .disclosureIndicator
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupConstraints()
        iconImageView.layer.cornerRadius = (contentView.height - 10) / 2
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        iconImageView.image = nil
        nameLabel.text = nil
    }
    
    func configure(with model: SearchResultDefaultTableCellViewModel){
        nameLabel.text = model.title
        iconImageView.sd_setImage(with: model.imageURL)
    }
    
    private func setupConstraints(){
      
        NSLayoutConstraint.activate(
            [
                //iconImageView
                iconImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5.0),
                iconImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 2.0),
                iconImageView.widthAnchor.constraint(equalTo: contentView.heightAnchor, constant: -10.0),
                iconImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, constant: -10.0),
                
                //nameLabel
                nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5.0),
                nameLabel.leftAnchor.constraint(equalTo: iconImageView.rightAnchor, constant: 10.0),
                nameLabel.rightAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.rightAnchor, constant: -5.0),

 
        ])
   }
}
