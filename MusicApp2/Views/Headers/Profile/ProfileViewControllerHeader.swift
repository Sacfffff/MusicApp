//
//  ProfileViewControllerHeader.swift
//  MusicApp2
//
//  Created by Aleks Kravtsova on 22.07.22.
//

import UIKit
import SDWebImage

final class ProfileViewControllerHeader  : UIView {
    
    private  let imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = CGRect(x: 0, y: 0, width: self.height / 2, height: self.height / 2)
        imageView.center = self.center
    }
    
    func setup(with image: URL?){
        imageView.sd_setImage(with: image)
        imageView.layer.cornerRadius = (self.height / 2) / 2
    }
}
