//
//  PlaybackPresenter.swift
//  MusicApp2
//
//  Created by Aleks Kravtsova on 11.07.22.
//

import AVFoundation
import UIKit



final class PlaybackPresenter {
    
    static let shared : PlaybackPresenter = PlaybackPresenter()
    private let playerModel : Player = Player()
  
    
    private init(){}
    
    func startPlayBack(from viewController: UIViewController, track: AudioTrack){
        guard let _ = URL(string: track.previewURL ?? " ") else {return}
        let vc = PlayerViewController()
        vc.title = track.name
        vc.dataSource = self
        vc.delegate = self.playerModel
        playerModel.delegatePlayerController = vc
        self.playerModel.playTrack(with: track)
        viewController.present(UINavigationController(rootViewController: vc), animated: true)
        
       
        
    }
    
    func startPlayBack(from viewController: UIViewController, tracks: [AudioTrack]){
        let vc = PlayerViewController()
        vc.dataSource = self
        vc.delegate = self.playerModel
        playerModel.delegatePlayerController = vc
        self.playerModel.playTracks(with: tracks.filter({ $0.previewURL != nil }))
            viewController.present(UINavigationController(rootViewController: vc), animated: true)
        
     

    }
    
   
}

//MARK: - extension PlayerPresenterDataSource
extension PlaybackPresenter : PlayerPresenterDataSource {
    var track: AudioTrack? {
        return playerModel.getCurrentTrack()
    }
    
}


