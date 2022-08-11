//
//  SettingsViewModel.swift
//  MusicApp2
//
//  Created by Aleks Kravtsova on 7.07.22.
//

import Foundation

protocol SettingsViewModelProtocol {
    var sections : [Sections] {get set}
    
}

final class SettingsViewModel : SettingsViewModelProtocol {

    var sections: [Sections] = []
    
    
    
}
