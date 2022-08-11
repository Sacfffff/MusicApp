//
//  APICaller.swift
//  MusicApp2
//
//  Created by Aleks Kravtsova on 13.06.22.
//

import Foundation

final class APICallerBrowse {
 
    private let requestSessionService : RequestSessionService = RequestSessionService()
    
    private enum Constants {
        static let baseAPIUrl = "https://api.spotify.com/v1"
        static let browseGetNewReleasesAddingURL = "/browse/new-releases?limit=30"
        static let browseGetFeaturedPlaylistAddingURL = "/browse/featured-playlists?limit=20"
        static let browseGetRecommendationsAddingURL = "/recommendations?limit=40&seed_genres="
        static let browseGetRecommendedGenresAddingURL = "/recommendations/available-genre-seeds"
        static let browseGetCategoriesAddingUrl = "/browse/categories"
        
    }
    
    
    public func getNewReleases(completion: @escaping ((Result<NewReleasesResponse, Error>) -> Void)){
        requestSessionService.createRequest(with: URL(string: Constants.baseAPIUrl + Constants.browseGetNewReleasesAddingURL), type: .GET) { [weak self] request in
            self?.requestSessionService.createURLSession(with: request, completion: completion)
        }
    }
    
    
    public func getFeaturedPlaylist(completion: @escaping ((Result<FeaturedPlaylistResponse, Error>) -> Void)) {
        requestSessionService.createRequest(with: URL(string: Constants.baseAPIUrl + Constants.browseGetFeaturedPlaylistAddingURL),
                      type: .GET
        ) { [weak self ] request in
            self?.requestSessionService.createURLSession(with: request, completion: completion)
        }
    }
    
    public func getRecommendations(genres: Set<String>, completion: @escaping ((Result<RecommendationsResponse, Error>) -> Void)) {
        let seeds = genres.joined(separator: ",")
        requestSessionService.createRequest(with: URL(string: Constants.baseAPIUrl + Constants.browseGetRecommendationsAddingURL+"\(seeds)"),
                      type: .GET)
        { [weak self] request in
            self?.requestSessionService.createURLSession(with: request, completion: completion)
        }
    }
    
    
    public func getRecommendedGenres(completion: @escaping ((Result<RecommendedGenresResponse, Error>) -> Void)) {
        requestSessionService.createRequest(with: URL(string: Constants.baseAPIUrl + Constants.browseGetRecommendedGenresAddingURL),
                      type: .GET
        ){ [weak self] request in
            self?.requestSessionService.createURLSession(with: request, completion: completion)
        }
    }
    
    public func getCategories(completion: @escaping (Result<AllCategoriesResponse,Error>) -> Void){
        requestSessionService.createRequest(with: URL(string: Constants.baseAPIUrl + Constants.browseGetCategoriesAddingUrl), type: .GET) { [weak self] request in
            self?.requestSessionService.createURLSession(with: request, completion: completion)
        }
    }
    
    public func getCategoryPlaylist(category: Category, completion: @escaping (Result<CategoryPlaylistResponse,Error>) -> Void){
        requestSessionService.createRequest(with: URL(string: Constants.baseAPIUrl + Constants.browseGetCategoriesAddingUrl + "/\(category.id)/playlists?limit=20"), type: .GET) { [weak self] request in
            self?.requestSessionService.createURLSession(with: request, completion: completion)
        }
    }
            
}


