//
//  LibraryAlbumsResponce.swift
//  MusicApp2
//
//  Created by Aleks Kravtsova on 20.07.22.
//


struct LibraryAlbumsResponce : Codable {
    let items: [SavedAlbum]
}

struct SavedAlbum : Codable {
    
    private enum CodingKeys : String, CodingKey {
        case addedAt = "added_at"
        case album
        
    }
    
    let addedAt : String
    let album : Album
}
