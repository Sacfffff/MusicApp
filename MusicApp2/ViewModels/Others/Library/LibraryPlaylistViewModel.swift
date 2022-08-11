//
//  LibraryPlaylistViewModel.swift
//  MusicApp2
//
//  Created by Aleks Kravtsova on 16.07.22.
//

import Foundation

protocol LibraryPlaylistViewModelProtocol {
    var playlists : [Playlist] {get set}
    var update : (() -> Void)? {get set}
    var failure: (() -> Void)? {get set}
    func getCurrentUserPlaylists()
    func createPlaylist(with name: String)
    func deletePlaylist(index: Int)
}

struct LibraryPlaylistModel {
    var playlist : Playlist
    var tracks : [AudioTrack]
}

final class LibraryPlaylistViewModel : LibraryPlaylistViewModelProtocol {
 
    private let fetchService : FetchDataServicePlaylist = FetchDataServicePlaylist()
    
    var update: (() -> Void)?
    
    var failure: (() -> Void)?
   
    var playlistIDTrackID : [String: Set<String>] = [:]
    
    var playlists: [Playlist] = []
    
    func getCurrentUserPlaylists(){
        self.playlists = []
        fetchService.fetchDataForCurrentUserPlaylist{ [weak self] playlists, error in
            DispatchQueue.main.async {
                if error == nil, let playlists = playlists, let update = self?.update {
                    
                    self?.playlists = playlists
                    
                    update()
                } else {
                    print(error!.localizedDescription)}
                
            }
        }
    }
    
    func createPlaylist(with name: String)  {
     
        fetchService.fetchDataCreatePlaylist(with: name) { [weak self] success in
               DispatchQueue.main.async {
                   if success {
                       self?.getCurrentUserPlaylists()
                   } else if let failure = self?.failure {
                       failure()}
                   
               }
           }
    
       }
    
    func deletePlaylist(index : Int){
        DispatchQueue.main.async { [weak self] in
            guard let update = self?.update else {return}
            self?.playlists.remove(at: index)
            update()
        }
      
    }
}
