//
//  SearchResultSubTitleTableViewCell.swift
//  MusicApp2
//
//  Created by Aleks Kravtsova on 10.07.22.
//

import SDWebImage
import UIKit

class SubtitleTableViewCell: UITableViewCell {
    
    private let titleLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subtitleLabel : UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 15, weight: .thin)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let iconImageView : UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "photo"))
        imageView.tintColor = .gray
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(titleLabel)
        addSubview(iconImageView)
        addSubview(subtitleLabel)
        contentView.clipsToBounds = true
        accessoryType = .disclosureIndicator
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
        iconImageView.image = nil
        titleLabel.text = nil
        subtitleLabel.text = nil
    }
    
    func configure(with model: SubtitleTableViewCellViewModel){
        titleLabel.text = model.title
        iconImageView.sd_setImage(with: model.imageURL, placeholderImage: UIImage(systemName: "photo"))
        subtitleLabel.text = model.subtitle
    }
    
    private func setupConstraints(){
      
        NSLayoutConstraint.activate(
            [
                //iconImageView
                iconImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5.0),
                iconImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 2.0),
                iconImageView.widthAnchor.constraint(equalTo: contentView.heightAnchor, constant: -10.0),
                iconImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, constant: -10.0),
                
                //titleLabel
                titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 3.0),
                titleLabel.leftAnchor.constraint(equalTo: iconImageView.rightAnchor, constant: 10.0),
                titleLabel.rightAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.rightAnchor, constant: -5.0),
                
                //subtitleLabel
                subtitleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -1.0),
                subtitleLabel.leftAnchor.constraint(equalTo: iconImageView.rightAnchor, constant: 10.0),
 

 
        ])
   }
}
