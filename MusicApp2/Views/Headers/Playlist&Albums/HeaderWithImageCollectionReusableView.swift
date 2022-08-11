//
//  PlaylistHeaderCollectionReusableView.swift
//  MusicApp2
//
//  Created by Aleks Kravtsova on 3.07.22.
//

import SDWebImage
import UIKit

protocol HeaderWithImageCollectionReusableViewDelegate : AnyObject {
    func playHeaderCollectionReusableViewDidTapPlayAll(_ header: HeaderWithImageCollectionReusableView)
}

final class HeaderWithImageCollectionReusableView: UICollectionReusableView {
    
    weak var delegate : HeaderWithImageCollectionReusableViewDelegate?
    
    private var nameLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    private var descriptionLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.numberOfLines = 2
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    private var ownerLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .thin)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "photo"))
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = .gray
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let blurView : UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let view = UIVisualEffectView(effect: blurEffect)
        return view
    }()
    
    private let playAllButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGreen
        let image = UIImage(systemName: "play.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30, weight: .regular))
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 30
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    //MARK: - Init
    override init(frame: CGRect){
        super.init(frame: frame)
        backgroundColor = .systemBackground
        addSubview(backgroundImageView)
        addSubview(blurView)
        addSubview(nameLabel)
        addSubview(descriptionLabel)
        addSubview(imageView)
        addSubview(ownerLabel)
        addSubview(playAllButton)
        playAllButton.addTarget(self, action: #selector(playAllButtonDidTap), for: .touchUpInside)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundImageView.frame = self.bounds
        blurView.frame = self.bounds
       setupConstraints()
        imageView.layer.cornerRadius = imageView.height / 2

       
    }
    
    func setup(with viewModel: HeaderWithImageVViewModel){
        backgroundImageView.sd_setImage(with: viewModel.artworkURL)
        nameLabel.text = viewModel.name
        ownerLabel.text = viewModel.ownerName
        descriptionLabel.text = viewModel.description
        imageView.sd_setImage(with:viewModel.artworkURL, placeholderImage: UIImage(systemName: "photo"))
        
    }
    
   @objc private func playAllButtonDidTap(){
       delegate?.playHeaderCollectionReusableViewDidTapPlayAll(self)
    }
    
    private func setupConstraints(){
      
        
        NSLayoutConstraint.activate(
            [
                //imageView
                imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 20.0),
                imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                imageView.widthAnchor.constraint(equalToConstant: height / 1.8),
                imageView.heightAnchor.constraint(equalToConstant: height / 1.8),
                
                //nameLabel
                nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 15.0),
                nameLabel.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor, constant: 10.0),
                nameLabel.rightAnchor.constraint(equalTo:  self.safeAreaLayoutGuide.rightAnchor, constant: -10.0),
                nameLabel.widthAnchor.constraint(equalToConstant: width - 20),
                
                //descriptionLabel
                descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 15.0),
                descriptionLabel.leftAnchor.constraint(equalTo:  self.safeAreaLayoutGuide.leftAnchor, constant: 10.0),
                descriptionLabel.rightAnchor.constraint(equalTo:  self.safeAreaLayoutGuide.rightAnchor, constant: -5.0),
                
                //ownerLabel
                ownerLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                ownerLabel.widthAnchor.constraint(equalToConstant: width - 20),
                ownerLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10.0),
                
                //playAllButton
                playAllButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 5.0),
                playAllButton.rightAnchor.constraint(equalTo:  self.rightAnchor, constant: -8.0),
                playAllButton.widthAnchor.constraint(equalToConstant: 60.0),
                playAllButton.heightAnchor.constraint(equalToConstant: 60.0)
                
            ])
    }
}
