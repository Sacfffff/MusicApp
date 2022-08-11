//
//  AlbumDetailsResponse.swift
//  MusicApp2
//
//  Created by Aleks Kravtsova on 2.07.22.
//

import Foundation

struct AlbumDetailsResponse : Codable {
    
    private enum CodingKeys : String, CodingKey {
        case albumType = "album_type"
        case artists
        case availableMarkets =  "available_markets"
        case externalURLs = "external_urls"
        case id
        case images
        case label
        case tracks
        case name
    }
    
    let albumType : String
    let artists : [Artist]
    let availableMarkets : [String]
    let externalURLs : [String : String]
    let id : String
    let images : [APIImage]
    let name : String
    let label : String
    let tracks : TrackResponse
}



