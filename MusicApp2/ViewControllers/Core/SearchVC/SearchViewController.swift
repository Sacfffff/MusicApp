//
//  SearchViewController.swift
//  MusicApp2
//
//  Created by Aleks Kravtsova on 13.06.22.
//

import UIKit

class SearchViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
 
        setupView()
       
    }
    

    private func setupView(){
        title = "Search"
        view.backgroundColor = .systemBackground
    }

}
