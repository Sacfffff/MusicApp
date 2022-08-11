//
//  Artist.swift
//  MusicApp2
//
//  Created by Aleks Kravtsova on 13.06.22.
//

import Foundation

struct Artist : Codable {
    
    private enum CodingKeys : String, CodingKey {
        case id
        case name
        case type
        case externalURLs =  "external_urls"
        case images
        
        
    }
    
    let id : String
    let name : String
    let type : String
    let externalURLs :  [String : String]
    let images : [APIImage]?
    
}
