//
//  MainScreenViewController.swift
//  MusicApp2
//
//  Created by Aleks Kravtsova on 13.06.22.
//

import UIKit

final class MainScreenVC : UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        setupView()
       
    }
    

    private func setupView(){
        title = "Home"
        view.backgroundColor = .systemBackground
    }
    
}
