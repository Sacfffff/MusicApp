//
//  ProfileViewCell.swift
//  MusicApp2
//
//  Created by Aleks Kravtsova on 22.07.22.
//

import UIKit

final class ProfileViewCell : UITableViewCell {
    
    @IBOutlet private weak var titleLabel : UILabel!
    
    @IBOutlet private weak var descriptionLabel : UILabel!
    
    @IBOutlet private weak var choosenView : UIView!
    
    
    func setup(with model: ProfileCellViewModel){
        titleLabel.text = model.title
        descriptionLabel.text = model.description
    }
    
   

}


