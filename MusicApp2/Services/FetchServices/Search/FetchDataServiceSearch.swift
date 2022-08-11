//
//  FetchDataServiceSearch.swift
//  MusicApp2
//
//  Created by Aleks Kravtsova on 9.07.22.
//

import Foundation


final class FetchDataServiceSearch {
    
    private let apiCaller : APICallerSearch = APICallerSearch()
    
    func fetchDataForSearch(with query: String, completion: @escaping ([SearchResult]?, Error?) -> Void) {
        apiCaller.search(with: query)
        { result in
            switch result {
            case .success(let result): 
                var searchResults : [SearchResult] = []
                searchResults.append(contentsOf: result.tracks.items.compactMap{.track(model: $0)})
                searchResults.append(contentsOf: result.playlists.items.compactMap{.playlist(model: $0)})
                searchResults.append(contentsOf: result.albums.items.compactMap{.album(model: $0)})
                searchResults.append(contentsOf: result.artists.items.compactMap{.artist(model: $0)})
                completion(searchResults, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    

}
