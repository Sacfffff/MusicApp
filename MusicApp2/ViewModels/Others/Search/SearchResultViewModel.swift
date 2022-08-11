//
//  SearchResultViewModel.swift
//  MusicApp2
//
//  Created by Aleks Kravtsova on 9.07.22.
//

import Foundation
import UIKit

protocol SearchResultViewModelProtocol {
    var sections : [SearchSection] {get}
    var isHidden : Bool {get}
    var update: (() -> Void)? {get set}
    func configure(with: [SearchResult])
    func addTrack(track: AudioTrack, _ target: UIViewController)
}


final class SearchResultViewModel : SearchResultViewModelProtocol {
    private let addTrackControls : AddTracksControls = AddTracksControls()
    
    var update: (() -> Void)?
    
    var isHidden : Bool = {
       return true
    }()
    
    var sections : [SearchSection] = [] {
        didSet {
            update?()
        }
    }
    
    func configure(with results: [SearchResult]) {
            let artists = results.filter({
               
                switch $0 {
                case .artist:
                    return true
                default :
                    return false
                }
                
            })
            let albums = results.filter({
               
                switch $0 {
                case .album:
                    return true
                default :
                    return false
                }
                
            })
            let tracks = results.filter({
               
                switch $0 {
                case .track:
                    return true
                default :
                    return false
                }
                
            })
            let playlist = results.filter({
               
                switch $0 {
                case .playlist:
                    return true
                default :
                    return false
                }
                
            })
            
            self.sections =
            [
                SearchSection(title: "Songs", results: tracks),
                SearchSection(title: "Artists", results: artists),
                SearchSection(title: "Playlists", results: playlist),
                SearchSection(title: "Albums", results: albums),
            ]
         
        isHidden = results.isEmpty
          
        }
    
    func addTrack(track: AudioTrack, _ target: UIViewController) {
        addTrackControls.showAlertSheetForChosenTrack(track: track, vc: target)
        
    }
    
}
