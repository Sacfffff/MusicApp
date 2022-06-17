//
//  AuthResponce.swift
//  MusicApp2
//
//  Created by Aleks Kravtsova on 15.06.22.
//

import UIKit

struct AuthResponce : Codable {
    
    enum CodingKeys : String, CodingKey {
        case accessToken = "access_token"
        case expiresIn = "expires_in"
        case refreshToken = "refresh_token"
        case scope
        case tokenType = "token_type"
        
    }
    
    let accessToken : String
    let expiresIn : Int
    let refreshToken : String?
    let scope : String
    let tokenType : String
}


