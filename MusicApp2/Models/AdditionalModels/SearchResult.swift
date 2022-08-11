//
//  SearchResult.swift
//  MusicApp2
//
//  Created by Aleks Kravtsova on 9.07.22.
//

import Foundation

enum SearchResult {
    case artist(model: Artist)
    case album(model: Album)
    case track(model: AudioTrack)
    case playlist(model: Playlist)
}
