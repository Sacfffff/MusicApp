//
//  Albums.swift
//  MusicApp2
//
//  Created by Aleks Kravtsova on 22.06.22.
//

import Foundation

struct Album : Codable {
    private enum CodingKeys : String, CodingKey {
        case albumType = "album_type"
        case availableMarkets = "available_markets"
        case id
        case images
        case name
        case releaseDate = "release_date"
        case totalTracks = "total_tracks"
        case artists
    }
    
    let albumType : String
    let availableMarkets : [String]
    let id : String
    var images : [APIImage]
    let name : String
    let releaseDate : String
    let totalTracks : Int
    let artists: [Artist]
    
}
