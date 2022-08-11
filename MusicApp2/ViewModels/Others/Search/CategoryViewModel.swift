//
//  CategoryViewModel.swift
//  MusicApp2
//
//  Created by Aleks Kravtsova on 8.07.22.
//

import Foundation

protocol CategoryViewModelProtocol {
    var category : Category {get}
    var playlists : [Playlist] {get}
    var update : (() -> Void)? {get set}
    
    func fetchData()
}

final class CategoryViewModel : CategoryViewModelProtocol {
    
    private let fetchService : FetchDataServiceCategory = FetchDataServiceCategory()
    
    var update: (() -> Void)?
    
    var category: Category
    
    var playlists: [Playlist] = [] {
        didSet{
            update?()
        }
    }
    
    init(category: Category){
        self.category = category
    }
   
    func fetchData() {
        fetchService.fetchDataForCategoryPlaylist(with: category) { [weak self] model, error in
            DispatchQueue.main.async {
                if error == nil, let model = model {
                    self?.playlists = model
                } else {print(error!.localizedDescription)}
                
            }
            
        }
    }
    
}
