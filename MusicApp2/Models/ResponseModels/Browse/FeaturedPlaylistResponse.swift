//
//  FeaturedPlaylistResponse.swift
//  MusicApp2
//
//  Created by Aleks Kravtsova on 24.06.22.
//


struct FeaturedPlaylistResponse : Codable {
    let playlists : PlaylistResponse
}


struct CategoryPlaylistResponse : Codable {
    let playlists : PlaylistResponse
}


struct PlaylistResponse : Codable {
    let items : [Playlist]?
}
