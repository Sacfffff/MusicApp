//
//  UserProfile.swift
//  MusicApp2
//
//  Created by Aleks Kravtsova on 13.06.22.
//

import Foundation

struct UserProfile : Codable {
    
    private enum CodingKeys : String, CodingKey {
        case country
        case displayName = "display_name"
        case email
        case explicitContent = "explicit_content"
        case externalURLs = "external_urls"
        case id
        case product
        case images
        
    }
    
    let country : String
    let displayName : String
    let email : String
    let explicitContent : [String: Bool]
    let externalURLs : [String : String]
    let id : String
    let product : String
    let images : [APIImage]
    
}



