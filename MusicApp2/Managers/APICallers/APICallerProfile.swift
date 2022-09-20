//
//  APICallerProfile.swift
//  MusicApp2
//
//  Created by Aleks Kravtsova on 28.06.22.
//

import Foundation
import Combine

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
    
//    public func getCurrentUserProfile() -> Future<UserProfile, Error> {
//        return Future<UserProfile, Error> { promise in
//            self.requestSessionService.createRequest(with: URL(string: Constants.baseAPIUrl + Constants.userRequestAddingURL), type: .GET)
//                .sink { [weak self] request in
//                     self?.getCurrentUserProfile()
//                        .sink(receiveCompletion: { completion in
//                            switch completion {
//                            case .failure(let error):
//                                promise(.failure(error))
//                            }
//                        }, receiveValue: { value in
//                            promise(.success(value))
//                        })
//                }
//        }
//
//    }
}


