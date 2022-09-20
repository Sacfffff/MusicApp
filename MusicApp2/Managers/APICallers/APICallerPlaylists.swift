//
//  APICallerPlaylist.swift
//  MusicApp2
//
//  Created by Aleks Kravtsova on 2.07.22.
//

import Foundation

final class APICallerPlaylist {
    
 
    private let requestSessionService : RequestSessionService = RequestSessionService()
    private let fetchDataProfile : FetchDataServiceProfile = FetchDataServiceProfile()
    private enum Constants {
        static let baseAPIUrl = "https://api.spotify.com/v1"
        static let getPlaylistAddingUrl = "/playlists/"
        static let getCurrentUserPlaylistAddingUrl = "/me/playlists/?limit=50"
      
    }
    

    func getPlaylistDetails(for  playlist: Playlist, completion: @escaping (Result<PlaylistDetailsResponse,Error>) -> Void){
        requestSessionService.createRequest(with: URL(string: Constants.baseAPIUrl + Constants.getPlaylistAddingUrl + playlist.id),
                                            type: .GET)
        { [weak self] request in
            self?.requestSessionService.createURLSession(with: request, completion: completion)
        }
    }
    
    func getCurrentUserPlaylist(completion: @escaping (Result<LibraryPlaylistResponce, Error>) -> Void){
        requestSessionService.createRequest(with: URL(string: Constants.baseAPIUrl + Constants.getCurrentUserPlaylistAddingUrl), type: .GET) { [weak self] request in
            self?.requestSessionService.createURLSession(with: request, completion: completion)
        }
    }
    
    func createPlaylist(with name: String, completion: @escaping (Result<Playlist,Error>) -> Void){
        
        fetchDataProfile.fetchDataForProfile { [weak self] userData, _ in
            if let userData = userData {
                let urlProfilePlaylists = Constants.baseAPIUrl + "/users/\(userData.id)/playlists"
                print(urlProfilePlaylists)
                self?.requestSessionService.createRequest(with: URL(string: urlProfilePlaylists), type: .POST) { [weak self] baseRequest in
                    let parametrs : [String: Any] =
                    [
                        "name" : name
                    ]
                    var request = baseRequest
                    
                    request.httpBody = try? JSONSerialization.data(withJSONObject: parametrs, options: .fragmentsAllowed)
                    
                    self?.requestSessionService.createURLSession(with: request, completion: completion)
                }
                
            }
        }
        
    }
    
    func addTrackToPlaylist(track: AudioTrack, playlist: Playlist, completion: @escaping (Result<[String : String],Error>) -> Void){
        requestSessionService.createRequest(with: URL(string: Constants.baseAPIUrl + "/playlists/\(playlist.id)/tracks"), type: .POST) { [weak self] baseRequest in
            var request = baseRequest
            let json =
            [
                "uris": ["spotify:track:\(track.id)"]
            ]
            request.httpBody = try? JSONSerialization.data(withJSONObject: json, options: .fragmentsAllowed)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            self?.requestSessionService.createURLSession(with: request, completion: completion)
        }
    }
    
    func removeTrackFromPlaylist(track: AudioTrack, playlist: Playlist, completion: @escaping (Result<[String : String],Error>) -> Void){
        requestSessionService.createRequest(with: URL(string: Constants.baseAPIUrl + Constants.getPlaylistAddingUrl + "\(playlist.id)/tracks"), type: .DELETE) { [weak self] baseRequest in
            var request = baseRequest
            let json = [
                "tracks" : [
                    [
                        "uri":"spotify:track:\(track.id)"
                    ]
                ]
                    
            ]
            request.httpBody = try? JSONSerialization.data(withJSONObject: json, options: .fragmentsAllowed)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            self?.requestSessionService.createURLSession(with: request, completion: completion)
        }
    }
    
    func getAllPlaylistTrack(playlist: Playlist, completion: @escaping ((Result<TrackPlaylistResponse, Error>) -> Void)){
        requestSessionService.createRequest(with: URL(string: Constants.baseAPIUrl + Constants.getPlaylistAddingUrl + "\(playlist.id)/tracks"), type: .GET) { [weak self] request in
            self?.requestSessionService.createURLSession(with: request, completion: completion)
         
        }
    }
    
  
            
}

