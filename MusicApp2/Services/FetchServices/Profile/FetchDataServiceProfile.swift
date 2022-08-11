//
//  FetchDataServiceProfile.swift
//  MusicApp2
//
//  Created by Aleks Kravtsova on 7.07.22.
//

import Foundation

final class FetchDataServiceProfile {
    
    private let apiCaller : APICallerProfile = APICallerProfile()
   
    
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
    
 

   
}
