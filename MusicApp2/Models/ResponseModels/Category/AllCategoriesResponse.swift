//
//  AllCategoriesResponse.swift
//  MusicApp2
//
//  Created by Aleks Kravtsova on 8.07.22.
//

import Foundation

struct AllCategoriesResponse : Codable {
    let categories : Categories
    
}

struct Categories : Codable{
    let items : [Category]
}

struct Category : Codable {
    let id : String
    let name : String
    let icons : [APIImage]
}
