//
//  PlayerPresenterDataSource.swift
//  MusicApp2
//
//  Created by Aleks Kravtsova on 12.07.22.
//

import Foundation

protocol PlayerPresenterDataSource : AnyObject {
    var track : AudioTrack? {get}
}
