//
//  FetchDataServisePlaylist.swift
//  MusicApp2
//
//  Created by Aleks Kravtsova on 2.07.22.
//

import Foundation


final class FetchDataServicePlaylist {
    
    private let apiCaller : APICallerPlaylist = APICallerPlaylist()
    private let profile : FetchDataServiceProfile = FetchDataServiceProfile()
    
    
    func fetchDataForPlaylistDetails(with playlist: Playlist, completion: @escaping (PlaylistDetailsResponse?, Error?) -> Void){
        
        apiCaller.getPlaylistDetails(for: playlist)
        { result in
            
            switch result {
            case .success(let model):
                completion(model, nil)
            case .failure(let error):
                completion(nil,error)
                
            }
            
        }
        
    }
    
    func fetchDataForCurrentUserPlaylist(completion: @escaping ([Playlist]?, Error?) -> Void){
        apiCaller.getCurrentUserPlaylist { result in
            switch result {
            case .success(let model):
                completion(model.items, nil)
            case .failure(let error):
                completion(nil,error)
                
            }
        }
    }
    
    func fetchDataCreatePlaylist(with name: String, completion: @escaping (Bool) -> Void){
        apiCaller.createPlaylist(with: name) { result in
            switch result {
            case .success(_):
                completion(true)
            case .failure(_):
                completion(false)
                
            }
        }
    }
    
    func fetchDataAddTrackToPlaylist(track: AudioTrack, playlist: Playlist, completion: @escaping (Bool) -> Void){
                self.apiCaller.addTrackToPlaylist(track: track, playlist: playlist) { result in
                    switch result {
                    case .success(_):
                        completion(true)
                    case .failure(_):
                        completion(false)
                        
                    }
                }
     
    }
    
    private func fetchAllTracksFromPlaylist(playlist: Playlist, completion: @escaping ([AudioTrack]?) -> Void){
        apiCaller.getAllPlaylistTrack(playlist: playlist) { result in
            switch result {
            case .success(let model):
                completion(model.items.compactMap{ $0.track })
            case .failure(_):
                completion(nil)
                
            }
        }
    }
    

    
     func fetchDataRemoveTrackFromPlaylist(track: AudioTrack, playlist: Playlist, completion: @escaping (Bool) -> Void){
        apiCaller.removeTrackFromPlaylist(track: track, playlist: playlist) { result in
            switch result {
            case .success(_):
                completion(true)
            case .failure(_):
                completion(false)
                
            }
        }
    }
    
    func isExistedCurrentTrack(track: AudioTrack, to playlist: Playlist, completion: @escaping (Bool) -> Void){
     fetchAllTracksFromPlaylist(playlist: playlist) { tracks in
            if let tracks = tracks, tracks.contains(where: { ($0.name == track.name && $0.artists.first?.name == track.artists.first?.name) }){
                
                completion(true)
                
                
            } else {
                
                completion(false)
            }
            
        }
    }
   
}


