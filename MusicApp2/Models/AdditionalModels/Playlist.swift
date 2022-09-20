//
//  Playlist.swift
//  MusicApp2
//
//  Created by Aleks Kravtsova on 13.06.22.
//

import UIKit


struct Playlist : Codable {
    private enum CodingKeys : String, CodingKey {
        case description
        case externalURLs = "external_urls"
        case id
        case images
        case name
        case owner
    }
    
    let description : String
    let externalURLs : [String: String]
    let id : String
    let images : [APIImage]?
    let name : String
    let owner : User
}
