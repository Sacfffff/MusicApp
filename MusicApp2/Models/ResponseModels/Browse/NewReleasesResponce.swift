//
//  NewReleasesResponse.swift
//  MusicApp2
//
//  Created by Aleks Kravtsova on 22.06.22.
//

import Foundation

struct NewReleasesResponse : Codable {
    
    let albums : AlbumsResponse
}



struct AlbumsResponse : Codable {
    let items : [Album]
}

