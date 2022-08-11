//
//  PlaylistViewModel.swift
//  MusicApp2
//
//  Created by Aleks Kravtsova on 7.07.22.
//

import Foundation
import UIKit

protocol PlaylistViewModelProtocol {
    var playlist : Playlist {get}
    var listOfTrackModels : [ListOfTrackCellViewModel] {get}
    var update : (() -> Void)? {get set}
    var tracks : [AudioTrack] {get set}
    var isOwner : Bool {get set}
    
    func fetchData()
    func removeTrack(track: AudioTrack, from playlist: Playlist, by index: Int)
    func addTrack(track: AudioTrack, _ target: UIViewController)
}

final class PlaylistViewModel : PlaylistViewModelProtocol {

    private let fetchService : FetchDataServicePlaylist = FetchDataServicePlaylist()
    
    private let addTrackControls : AddTracksControls =  AddTracksControls()
    
    var isOwner : Bool = false
    
    var playlist: Playlist
    
    var tracks: [AudioTrack] = []
    
    var update: (() -> Void)?
    
    var listOfTrackModels : [ListOfTrackCellViewModel] = [] {
        didSet{
            update?()
        }
    }
    
    init(playlist: Playlist){
        self.playlist = playlist
    }
    
    func fetchData() {
        self.tracks = []
        self.listOfTrackModels = []
        self.fetchService.fetchDataForPlaylistDetails(with: playlist) { [weak self] model, error in
            DispatchQueue.main.async {
                if error == nil, let model = model {
                    self?.tracks = model.tracks.items.compactMap({ $0.track })
                    self?.listOfTrackModels = model.tracks.items.compactMap {
                        return ListOfTrackCellViewModel(songName: $0.track.name,
                                                        artistName: $0.track.artists.first?.name ?? "-",
                                                        artworkURL: URL(string: $0.track.album?.images.first?.url ?? " "))
                    }
                } else {print(error!.localizedDescription)}

            }

        }

    }
    
    func removeTrack(track: AudioTrack, from playlist: Playlist, by index: Int){
        fetchService.fetchDataRemoveTrackFromPlaylist(track: track, playlist: playlist) { [weak self] success in
            DispatchQueue.main.async {
                if success, let update = self?.update {
                       update()
                    }
            }
        }
    }
    
    func addTrack(track: AudioTrack, _ target: UIViewController) {
        addTrackControls.showAlertSheetForChosenTrack(track: track, vc: target)
        
    }
    
}    
    

