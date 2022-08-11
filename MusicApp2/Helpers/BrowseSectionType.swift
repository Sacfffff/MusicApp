//
//  Browse.swift
//  MusicApp2
//
//  Created by Aleks Kravtsova on 1.07.22.
//

import Foundation

 enum BrowseSectionType {
    case newReleases(viewModels: [NewReleasesCellViewModel])
    case featuredPlaylist(viewModels: [AllPlaylistsCellViewModel])
    case recommendedTracks(viewModels: [ListOfTrackCellViewModel])
     
     var title: String {
         switch self {
         case .newReleases:
             return "New Released Albums"
         case .featuredPlaylist:
             return "Futured Playlist"
         case .recommendedTracks:
             return "Recommended"
         }
     }
 }
