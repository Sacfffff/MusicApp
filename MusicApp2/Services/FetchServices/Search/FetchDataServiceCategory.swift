//
//  FetchDataServiceSearch.swift
//  MusicApp2
//
//  Created by Aleks Kravtsova on 8.07.22.
//

import Foundation

final class FetchDataServiceCategory {
    
    private let apiCaller : APICallerBrowse = APICallerBrowse()
    func fetchDataForCategories(completion: @escaping ([Category]?, Error?) -> Void) {
        apiCaller.getCategories { result in
            switch result {
            case .success(let categories):
                completion(categories.categories.items, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
    func fetchDataForCategoryPlaylist(with category: Category, completion: @escaping ([Playlist]?, Error?) -> Void){
        apiCaller.getCategoryPlaylist(category: category) { result in
            switch result {
            case .success(let model):
                completion(model.playlists.items, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }

}
