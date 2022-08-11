//
//  FetchDataService.swift
//  MusicApp2
//
//  Created by Aleks Kravtsova on 29.06.22.
//

import Foundation



class FetchDataServiceBrowse {
    private let apiCaller : APICallerBrowse = APICallerBrowse()
   
    
    
    func fetchDataForNewReleases(completion: @escaping (NewReleasesResponse?, Error?) -> Void){
        apiCaller.getNewReleases { result in
            
            switch result {
            case .success(let model):
                completion(model, nil)
            case .failure(let error):
                completion(nil,error)
                
            }
        }
        
    }
    
    func fetchDataForFeaturedPlaylist(completion: @escaping (FeaturedPlaylistResponse?, Error?) -> Void) {
        apiCaller.getFeaturedPlaylist { result in
           
                switch result {
                case .success(let model):
                    completion(model, nil)
                case .failure(let error):
                    completion(nil,error)
                    
                }
            }
    }
    
    func fetchDataForRecommendations(completion: @escaping (RecommendationsResponse?, Error?) -> Void) {

            apiCaller.getRecommendedGenres {[weak self] result in
                switch result {
                case .success(let model):
                   let genres = model.genres
                    var seeds = Set<String>()
                    while seeds.count < 5 {
                        if let randomGenre = genres.randomElement() {
                            seeds.insert(randomGenre)
                        }
                    }
                    
                    self?.apiCaller.getRecommendations(genres: seeds) { recommendedResult in
                        switch recommendedResult {
                        case .success(let model):
                            completion(model, nil)
                        case .failure(let error):
                            completion(nil,error)
                            
                        }
                    }
                case .failure(let error):
                    completion(nil, error)
                }
            
        }

    }
    
   
   
}
