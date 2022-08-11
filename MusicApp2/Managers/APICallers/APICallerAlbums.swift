//
//  APICallerAlbums.swift
//  MusicApp2
//
//  Created by Aleks Kravtsova on 2.07.22.
//

import Foundation
final class APICallerAlbums {
 
    private let requestSessionService : RequestSessionService = RequestSessionService()
    private let fetchDataProfile : FetchDataServiceProfile = FetchDataServiceProfile()
    
    private enum Constants {
        static let baseAPIUrl = "https://api.spotify.com/v1"
        static let getAlbumAddingUrl = "/albums/"
        static let getSavedUserAlbumsAddingURL = "/me/albums"
      
    }
    

    func getAlbumDetails(for album: Album, completion: @escaping (Result<AlbumDetailsResponse,Error>) -> Void){
        requestSessionService.createRequest(with: URL(string: Constants.baseAPIUrl + Constants.getAlbumAddingUrl + "\(album.id)"), type: .GET)
        { [weak self] request in
            self?.requestSessionService.createURLSession(with: request, completion: completion)
        }
    }
    
    func getCurrentUserAlbums(completion: @escaping (Result<LibraryAlbumsResponce, Error>) -> Void){
        requestSessionService.createRequest(with: URL(string: Constants.baseAPIUrl + Constants.getSavedUserAlbumsAddingURL), type: .GET) { [weak self] request in
            self?.requestSessionService.createURLSession(with: request, completion: completion)
        }
    }
    
    func saveAlbums(album: Album, completion: @escaping (Bool) -> Void) {
        requestSessionService.createRequest(with: URL(string: Constants.baseAPIUrl + Constants.getSavedUserAlbumsAddingURL + "?ids=\(album.id)"), type: .PUT) {baseRequest in
            URLSession.shared.dataTask(with: baseRequest) { data, responce, error in
                guard let _ = data, let code = (responce as? HTTPURLResponse)?.statusCode,
                        error == nil else {
                    completion(false)
                    return
                }
               
                completion(code == 200)

            }.resume()
            
          
        }
        
        
    }
    
    func deleteAlbum(album: Album, completion: @escaping (Bool) -> Void) {
        requestSessionService.createRequest(with: URL(string: Constants.baseAPIUrl + Constants.getSavedUserAlbumsAddingURL + "?ids=\(album.id)"), type: .DELETE) {baseRequest in
            URLSession.shared.dataTask(with: baseRequest) { data, responce, error in
                guard let _ = data, let code = (responce as? HTTPURLResponse)?.statusCode,
                        error == nil else {
                    completion(false)
                    return
                }
               
                completion(code == 200)

            }.resume()
            
           
        }
        
        
    }
    
   
            
}

