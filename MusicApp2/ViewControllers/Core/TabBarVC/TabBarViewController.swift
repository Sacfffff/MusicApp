//
//  TabBarViewController.swift
//  MusicApp2
//
//  Created by Aleks Kravtsova on 13.06.22.
//

import UIKit



class TabBarViewController: UITabBarController {

    private var arrayOfViewControllers : [UIViewController] {
        return [MainScreenViewController(), SearchViewController(),  LibraryViewController()]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
     setupNavigationController()
    }
    

    private func setupNavigationController(){
        var navigationControllers : [UINavigationController] = []
        let tabBarViewControllers : [TabBarViewControllers] = TabBarViewControllers.getAll
        for (index, controller) in  arrayOfViewControllers.enumerated(){
            controller.navigationItem.largeTitleDisplayMode = .always
            let navigationController = UINavigationController(rootViewController: controller)
            navigationController.navigationBar.tintColor = .label
            navigationController.tabBarItem = UITabBarItem(title: tabBarViewControllers[index].title, image: tabBarViewControllers[index].image, tag: index)
           navigationController.navigationBar.prefersLargeTitles = true
            navigationControllers.append(navigationController)
        }
        setViewControllers(navigationControllers, animated: false)
    }
}

