//
//  APICallerSearch.swift
//  MusicApp2
//
//  Created by Aleks Kravtsova on 9.07.22.
//

import Foundation

final class APICallerSearch {
 
    private let requestSessionService : RequestSessionService = RequestSessionService()
    
    private enum Constants {
        static let baseAPIUrl = "https://api.spotify.com/v1"
        static let searchAddingURL = "/search?limit=8&type=album,artist,playlist,track&q="
    }
    
    public func search(with query: String, completion: @escaping (Result<SearchResultsResponse,Error>) -> Void){
        requestSessionService.createRequest(with: URL(string: Constants.baseAPIUrl + Constants.searchAddingURL + "\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? " ")"), type: .GET) { [weak self] request in
            self?.requestSessionService.createURLSession(with: request, completion: completion)
        }
    }
    
  
            
}
