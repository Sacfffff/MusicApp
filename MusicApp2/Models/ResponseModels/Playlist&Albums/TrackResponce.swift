//
//  TrackResponce.swift
//  MusicApp2
//
//  Created by Aleks Kravtsova on 18.07.22.
//

import Foundation

struct TrackResponse : Codable {
    let items : [AudioTrack]
    
}

struct TrackPlaylistResponse : Codable {
    let items : [AddedTracks]
    
}

struct AddedTracks : Codable {
    let track : AudioTrack
}
