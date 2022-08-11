//
//  APICallerProfile.swift
//  MusicApp2
//
//  Created by Aleks Kravtsova on 28.06.22.
//

import Foundation

final class APICallerProfile {
 
    private let requestSessionService : RequestSessionService = RequestSessionService()
    
    private enum Constants {
        static let baseAPIUrl = "https://api.spotify.com/v1"
        static let userRequestAddingURL = "/me"
    }
    
    
    public func getCurrentUserProfile(completion: @escaping (Result<UserProfile, Error>) -> Void){
        requestSessionService.createRequest(with: URL(string: Constants.baseAPIUrl + Constants.userRequestAddingURL),
                      type: .GET)
        { [weak self] request in
            self?.requestSessionService.createURLSession(with: request, completion: completion)
        }
    }
    
            
}


