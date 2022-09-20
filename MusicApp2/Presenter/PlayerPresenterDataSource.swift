//
//  PlayerPresenterDataSource.swift
//  MusicApp2
//
//  Created by Aleks Kravtsova on 12.07.22.
//

import Foundation

protocol PlayerPresenterDataSource : AnyObject {
    var track : AudioTrack? {get}
    
    var currentTime : Float {get}
    var duration : Float {get}
}
