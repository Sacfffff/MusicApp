//
//  SettingsModels.swift
//  MusicApp2
//
//  Created by Aleks Kravtsova on 18.06.22.
//

import UIKit

struct Sections {
    let title : String
    let options : [Option]
}

struct Option {
    let title : String
    let handler : () -> Void
}
