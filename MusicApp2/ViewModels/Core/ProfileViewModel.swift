//
//  ProfileViewModel.swift
//  MusicApp2
//
//  Created by Aleks Kravtsova on 7.07.22.
//

import Foundation

protocol ProfileViewModelProtocol {
    var models : [ProfileCellViewModel] {get set}
    var imageURL : String? {get set}
    var update : ((UserProfile) -> Void)? {get set}
    var failed : (() -> Void)? {get set}
    
    func fetchData()
}

final class ProfileViewModel : ProfileViewModelProtocol {
    
    var imageURL : String?
    
    var failed: (() -> Void)?
    
    var update: ((UserProfile) -> Void)?
 
    var models: [ProfileCellViewModel] = []
  
    private var fetchService : FetchDataServiceProfile = FetchDataServiceProfile()
    
    func fetchData() {
        guard let update = update, let failed = failed else {
            return
        }

        fetchService.fetchDataForProfile { model, error in
            DispatchQueue.main.async {
                if error == nil, let model = model {
                   update(model)
                } else {
                    failed()
                }
            }
        }
    }
    
   
    
    
}
