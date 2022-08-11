//
//  MainViewModel.swift
//  MusicApp2
//
//  Created by Aleks Kravtsova on 7.07.22.
//

import UIKit




protocol MainViewModelProtocol{
    var albums: [Album] {get}
    var playlists: [Playlist] {get}
    var tracks : [AudioTrack] {get}
    var sections : [BrowseSectionType] {get}
    var update : (() -> Void)? {get set}
 
    
    func fetchData()
    func addTrack(track: AudioTrack, _ target: UIViewController)
}

final class MainViewModel : MainViewModelProtocol {
    private let facadeBrowse : BrowseFacade = BrowseFacade()
  
    private let addTracksControls : AddTracksControls = AddTracksControls()
    
    var albums: [Album] = []
    
    var update: (() -> Void)?
    
    var sections : [BrowseSectionType] = [] {
        didSet {
            update?()
        }
    }
    
    var playlists: [Playlist] = []
    
    var tracks: [AudioTrack] = []
    
    func fetchData() {
        facadeBrowse.configure = configureModels(albums:playlists:tracks:)
        facadeBrowse.configureData()
    }
    
    
    private func configureModels(albums: [Album], playlists: [Playlist], tracks: [AudioTrack]){
        let differentValue = "-"
        self.albums = albums
        self.tracks = tracks
        self.playlists = playlists
        sections.append(.newReleases(viewModels: self.albums.compactMap({
            return NewReleasesCellViewModel(name: $0.name,
                                            artworkURL: URL(string: $0.images.first?.url ?? differentValue),
                                            numberOfTracks:$0.totalTracks,
                                            arttistName: $0.artists.first?.name ?? differentValue)
        })))
        
        sections.append(.featuredPlaylist(viewModels: self.playlists.compactMap ({
            return AllPlaylistsCellViewModel(name: $0.name,
                                                 artworkURL: URL(string: $0.images?.first?.url ?? differentValue),
                                                 creatorName: $0.owner.displayName)
        })))
        
        sections.append(.recommendedTracks(viewModels: self.tracks.compactMap({
            return ListOfTrackCellViewModel(songName: $0.name, artistName: $0.artists.first?.name ?? differentValue, artworkURL: URL(string: $0.album?.images.first?.url ?? differentValue))
        })))
        
    }

    func addTrack(track: AudioTrack, _ target : UIViewController) {
        addTracksControls.showAlertSheetForChosenTrack(track: track, vc: target)
    }
    
  
}
