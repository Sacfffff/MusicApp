//
//  LibraryAlbumViewModel.swift
//  MusicApp2
//
//  Created by Aleks Kravtsova on 20.07.22.
//

import Foundation

protocol LibraryAlbumViewModelProtocol {
    var albums : [Album] {get set}
    var update : (() -> Void)? {get set}
    var failure: (() -> Void)? {get set}
    var observer : NSObjectProtocol? {get set}
    func getCurrentUserAlbums()
    func deleteAlbum(album: Album)
}



final class LibraryAlbumViewModel : LibraryAlbumViewModelProtocol {
    
    private let fetchService : FetchDataServiceAlbum = FetchDataServiceAlbum()
    
    var observer: NSObjectProtocol?
    
    var update: (() -> Void)?
    
    var failure: (() -> Void)?
    
    var albums: [Album] = []
    
    func getCurrentUserAlbums(){
        self.albums.removeAll()
        fetchService.fetchDataForCurrentUserAlbums{ [weak self] albums, error in
            DispatchQueue.main.async {
                if error == nil, let albums = albums, let update = self?.update {
                    
                   self?.albums = albums
                    
                    update()
                } else {
                    print(error!.localizedDescription)}
                
            }
        }
    }
 
    func deleteAlbum(album : Album){
        fetchService.fetchDataDeleteAlbum(album: album) { [weak self] success in
            DispatchQueue.main.async {
                if success, let update = self?.update {
                    update()
                } else if !success, let failure = self?.failure {
                    failure()
                }
            }
            
        }
      
    }
}
