//
//  FetchDataServiceAlbums.swift
//  MusicApp2
//
//  Created by Aleks Kravtsova on 2.07.22.
//

import Foundation

final class FetchDataServiceAlbum {
    private let apiCaller : APICallerAlbums = APICallerAlbums()
    
    func fetchDataForAlbumDetails(with album: Album, completion: @escaping (AlbumDetailsResponse?, Error?) -> Void) {
        apiCaller.getAlbumDetails(for: album) { result in
            switch result {
            case .success(let model):
                completion(model, nil)
            case .failure(let error):
                completion(nil,error)
                
            }
        }
    }
    
    func fetchDataForCurrentUserAlbums(completion: @escaping ([Album]?, Error?) -> Void){
        apiCaller.getCurrentUserAlbums{result in
            switch result {
            case .success(let model):
                completion(model.items.compactMap({ $0.album}), nil)
            case .failure(let error):
                completion(nil,error)
                
            }
        }
    }
    
    func fetchDataForSaveAlbums(album: Album, completion: @escaping (Bool) -> Void){
        apiCaller.saveAlbums(album: album, completion: completion)
    }
    
    func fetchDataDeleteAlbum(album: Album, completion: @escaping (Bool) -> Void){
        apiCaller.deleteAlbum(album: album, completion: completion)
    }
}

