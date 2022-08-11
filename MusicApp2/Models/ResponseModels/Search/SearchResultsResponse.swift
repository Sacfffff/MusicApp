//
//  SearchResultsResponse.swift
//  MusicApp2
//
//  Created by Aleks Kravtsova on 9.07.22.
//

import Foundation

struct SearchResultsResponse : Codable {
    let albums : SearchAlbumResponse
    let artists : SearchArtistsResponse
    let playlists : SearchPlaylistsResponse
    let tracks : SearchTracksResponse
}

struct SearchArtistsResponse : Codable {
    let items : [Artist]
}

struct SearchAlbumResponse : Codable {
    let items : [Album]
}

struct SearchPlaylistsResponse : Codable {
    let items : [Playlist]
}

struct SearchTracksResponse : Codable {
    let items : [AudioTrack]
}
