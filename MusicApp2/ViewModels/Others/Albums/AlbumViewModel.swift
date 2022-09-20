//
//  AlbumViewModel.swift
//  MusicApp2
//
//  Created by Aleks Kravtsova on 7.07.22.
//

import Foundation
import UIKit

protocol AlbumViewModelProtocol {
    var album : Album {get}
    var albumTrackListModels : [AlbumTrackListViewModel] {get}
    var update : (() -> Void)? {get set}
    var failure : (() -> Void)? {get set}
    var tracks : [AudioTrack] {get}
    
    func fetchData()
    func addTrack(track: AudioTrack, _ target: UIViewController)
    func saveAlbum(album: Album)
    func deleteAlbum(album: Album)
    func isExistCurrentAlbumInCollection(album: Album, completion: @escaping (Bool) -> Void)
    
}

final class AlbumViewModel : AlbumViewModelProtocol {
    
    private let fetchService : FetchDataServiceAlbum = FetchDataServiceAlbum()
    private let addTracControls : AddTracksControls = AddTracksControls()
    
    var album: Album
    
    var tracks: [AudioTrack] = []
    
    var update: (() -> Void)?
    var failure : (() -> Void)?
    
    var albumTrackListModels : [AlbumTrackListViewModel] = [] {
        didSet{
            update?()
        }
    }
    
    init(album: Album){
        self.album = album
    }
    
    func fetchData() {
        self.fetchService.fetchDataForAlbumDetails(with: album) { [weak self] model, error in
            DispatchQueue.main.async {
                if error == nil, let model = model {
                    self?.tracks = model.tracks.items
                    self?.albumTrackListModels = model.tracks.items.compactMap {
                        return AlbumTrackListViewModel(songName: $0.name,
                                                       artistName: $0.artists.first?.name ?? "-")
                    }
                } else {print(error!)}
                
            }
            
        }
    }
    
    func addTrack(track: AudioTrack, _ target: UIViewController) {
        addTracControls.showAlertSheetForChosenTrack(track: track, vc: target)
    }
    
    func saveAlbum(album: Album){
        fetchService.fetchDataForSaveAlbums(album: album) { [weak self] success in
            DispatchQueue.main.async {
                if success, let update = self?.update {
                    update()
                } else if !success, let failure = self?.failure {
                    failure()
                }
            }
            
        }
    }
    
    func deleteAlbum(album: Album){
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
    
    
    func isExistCurrentAlbumInCollection(album: Album, completion: @escaping (Bool) -> Void) {
        fetchService.fetchDataForCurrentUserAlbums { albums, _ in
            DispatchQueue.main.async {
                guard let isExist = albums?.contains(where: { $0.name == album.name && $0.artists.first?.name == album.artists.first?.name}) else {
                    completion(false)
                    return}
                completion(isExist)
            }
            
        }
        
    }
}

