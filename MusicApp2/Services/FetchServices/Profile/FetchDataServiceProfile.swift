//
//  FetchDataServiceProfile.swift
//  MusicApp2
//
//  Created by Aleks Kravtsova on 7.07.22.
//

import Foundation
import Combine

final class FetchDataServiceProfile {
    
    private let apiCaller : APICallerProfile = APICallerProfile()
    private var cancellables = Set<AnyCancellable>()
   
    
    func fetchDataForProfile(completion: @escaping (UserProfile?, Error?) -> Void) {
        apiCaller.getCurrentUserProfile
        { result in
            
            switch result {
            case .success(let model):
                completion(model, nil)
            case .failure(let error):
                completion(nil,error)
            }

        }
        
    }
    
 
//    func fetchDataForProfile() -> Future<UserProfile, Error> {
//        return Future<UserProfile, Error>{ [weak self] promise in
//            guard let self = self else {
//                promise(.failure(APIError.failedToGetData))
//                return
//            }
//            self.apiCaller.getCurrentUserProfile()
//                .sink { completion in
//                    switch completion {
//                    case .failure(let err):
//                        promise(.failure(err))
//                    case .finished:
//                        print("Finished")
//                    }
//                }
//                receiveValue: { value in
//                    promise(.success(value))
//                }
//                .store(in: &self.cancellables)
//        }
        
      

        
        
   // }
    
    

   
}
