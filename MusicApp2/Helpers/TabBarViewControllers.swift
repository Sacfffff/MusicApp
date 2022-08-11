//
//  TabBarViewControllers.swift
//  MusicApp2
//
//  Created by Aleks Kravtsova on 2.08.22.
//

import UIKit

enum TabBarViewControllers {
    case mainScreen
    case searchScreen
    case libraryScreen
    
    var image : UIImage? {
        switch self {
        case .mainScreen:
            return UIImage(systemName: "house")
        case .libraryScreen:
            return UIImage(systemName: "music.note.list")
        case .searchScreen:
            return UIImage(systemName: "magnifyingglass")
        }
    }
        
        var title : String {
            switch self {
            case .mainScreen:
                return "Browse"
            case .libraryScreen:
                return "Library"
            case .searchScreen:
                return "Search"
            }
        }
    
    static var getAll : [TabBarViewControllers] {
        return [.mainScreen, .searchScreen, .libraryScreen]
    }
    
}
