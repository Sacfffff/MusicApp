//
//  User.swift
//  MusicApp2
//
//  Created by Aleks Kravtsova on 24.06.22.
//

import Foundation

struct User : Codable {
    private enum CodingKeys : String, CodingKey {
     case displayName = "display_name"
     case externalURLs = "external_urls"
     case id
    }
    
    let displayName : String
    let externalURLs : [String: String]
    let id : String
}
