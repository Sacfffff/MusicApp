//
//  TabBarViewController.swift
//  MusicApp2
//
//  Created by Aleks Kravtsova on 13.06.22.
//

import UIKit

class TabBarViewController: UITabBarController {

    private var arrayOfViewControllers : [UIViewController] {
        return [MainScreenVC(), SearchViewController(),  LibraryViewController()]
    }
    
    private var tabBarImages : [UIImage?] {
        return [UIImage(systemName: "house"), UIImage(systemName: "magnifyingglass"), UIImage(systemName: "music.note.list")]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
     setupNavigationController()
    }
    

    private func setupNavigationController(){
        var navigationControllers : [UINavigationController] = []
        for (index, controller) in  arrayOfViewControllers.enumerated(){
            controller.navigationItem.largeTitleDisplayMode = .always
            let navigationController = UINavigationController(rootViewController: controller)
            navigationController.tabBarItem = UITabBarItem(title: controller.title, image: tabBarImages[index], tag: index)
            navigationController.navigationBar.prefersLargeTitles = true
            navigationControllers.append(navigationController)
        }
        
        setViewControllers(navigationControllers, animated: false)
    }
}

