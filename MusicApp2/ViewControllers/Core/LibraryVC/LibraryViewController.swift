//
//  LibraryViewController.swift
//  MusicApp2
//
//  Created by Aleks Kravtsova on 13.06.22.
//

import UIKit

class LibraryViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
 
        setupView()
       
    }
    

    private func setupView(){
        title = "Library"
        view.backgroundColor = .systemBackground
    }
}
