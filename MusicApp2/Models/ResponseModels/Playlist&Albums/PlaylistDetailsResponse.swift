//
//  PlaylistDetailResponse.swift
//  MusicApp2
//
//  Created by Aleks Kravtsova on 2.07.22.
//

import Foundation

struct PlaylistDetailsResponse : Codable {
    
    private enum CodingKeys : String, CodingKey {
        case externalURLs = "external_urls"
        case description
        case id
        case images
        case name
        case tracks
       
    }
    
    let description : String
    let externalURLs : [String : String]
    let id : String
    let images : [APIImage]
    let name : String
    let tracks : PlaylistTrackResponse
    
}

struct PlaylistTrackResponse : Codable {
    let items : [PlaylistItem]
}

struct PlaylistItem : Codable {
    let track : AudioTrack
    
}
