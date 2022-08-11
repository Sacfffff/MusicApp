//
//  PlayerViewControllerViewModel.swift
//  MusicApp2
//
//  Created by Aleks Kravtsova on 25.07.22.
//

import Foundation
import UIKit

protocol PlayerViewModelProtocol {

    
    func addTrack(track: AudioTrack, _ target: UIViewController)
}


final class PlayerViewModel : PlayerViewModelProtocol{

    
    private var addTrackControls : AddTracksControls = AddTracksControls()
    
    func addTrack(track: AudioTrack, _ target: UIViewController){
        addTrackControls.showAlertSheetForChosenTrack(track: track, vc: target)
    }
}
