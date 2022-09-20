//
//  BrowseFacade.swift
//  MusicApp2
//
//  Created by Aleks Kravtsova on 2.08.22.
//

import Foundation

final class BrowseFacade {
    private let fetchServiceBrowse : FetchDataServiceBrowse = FetchDataServiceBrowse()
    
    var configure : (([Album], [Playlist], [AudioTrack]) -> Void)?
    
    func configureData() {
            let group = DispatchGroup()
            var newReleases : NewReleasesResponse?
            var featuredPlaylist : FeaturedPlaylistResponse?
            var recommendations : RecommendationsResponse?
        
        group.enter()
            fetchServiceBrowse.fetchDataForNewReleases {
                defer {
                    group.leave()
                }
                guard $1 == nil else {
                    print($1!)
                    return
                }
                    newReleases = $0
            }
            
        group.enter()
            fetchServiceBrowse.fetchDataForFeaturedPlaylist {
                defer {
                    group.leave()
                }
                guard $1 == nil else {
                    print($1)
                    return
                }
                featuredPlaylist = $0
            }
            
        group.enter()
            fetchServiceBrowse.fetchDataForRecommendations {
                defer {
                    group.leave()
                }
                guard $1 == nil else {
                    print($1!)
                    return
                }
                recommendations = $0
            }

            
        group.notify(queue: .main) { [weak self] in
            guard let newAlbums = newReleases?.albums.items,
                  let playlist = featuredPlaylist?.playlists.items,
                  let tracks = recommendations?.tracks,
                  let configure = self?.configure
                  else { return }
            configure(newAlbums, playlist, tracks)
            
            }
    }
    
    
}
