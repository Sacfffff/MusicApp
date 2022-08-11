//
//  AudioTrack.swift
//  MusicApp2
//
//  Created by Aleks Kravtsova on 13.06.22.
//

import Foundation

struct AudioTrack : Codable {
    
    private enum CodingKeys : String, CodingKey {
        case album
        case artists
        case availableMarkets =  "available_markets"
        case discNumber = "disc_number"
        case durationMs = "duration_ms"
        case explicit
        case externalURLs =  "external_urls"
        case id
        case name
        case previewURL = "preview_url"
        
    }
    
    var album : Album?
    let artists : [Artist]
    let availableMarkets : [String]
    let discNumber : Int
    let durationMs : Int
    let explicit : Bool
    let externalURLs : [String: String]
    let id : String
    let name : String
    let previewURL : String?
    
}

        



