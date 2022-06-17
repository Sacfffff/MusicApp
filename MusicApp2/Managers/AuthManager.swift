//
//  AuthManager.swift
//  MusicApp2
//
//  Created by Aleks Kravtsova on 13.06.22.
//

import UIKit

import SpotifyWebAPI

final class AuthManager {
    static let shared = AuthManager()
    
   private enum Constants {
        static let clienID = "24de390f182f4fdebe66e52273b02bc2"
        static let clientSecret = "ad47a455dd1247ceaa97ba77365cf829"
        static let redirectUri = URL(string:"https://vk.com/ess_pls")
       static let tokenAPIURL = "https://accounts.spotify.com/api/token"
       static let basicToken = "\(Constants.clienID):\(Constants.clientSecret)".data(using: .utf8)?.base64EncodedString()
    }
    
    private enum ConstantKeys {
        static let kAccessToken = "kAccessToken"
        static let kExpirationDate = "kExpirationDate"
        static let kRefreshToken = "kRefreshToken"
        static let kScope = "kScope"
        static let kTokenType = "kTokenType"
    }
    
    public var sighInURL : URL? {
        return spotify.authorizationManager.makeAuthorizationURL(
            redirectURI: Constants.redirectUri!,
            showDialog: true,
            scopes: [
                .playlistModifyPrivate,
                .playlistModifyPublic,
                .playlistReadPrivate,
                .userReadPrivate,
                .userFollowRead,
                .userLibraryModify,
                .userLibraryRead,
                .userReadEmail
            ])
    }
    
 private lazy var spotify = SpotifyAPI(authorizationManager: AuthorizationCodeFlowManager(clientId: Constants.clienID, clientSecret: Constants.clientSecret))
   
   public  var isSignedIn : Bool {
        return accessToken != nil
    }
    
    
    private var accessToken : String? {
        return UserDefaults.standard.string(forKey: ConstantKeys.kAccessToken)
    }
    
    private var refreshToken : String? {
        return UserDefaults.standard.string(forKey: ConstantKeys.kRefreshToken)
    }
    
    private var tokenExpirationDate: Date? {
        return UserDefaults.standard.value(forKey: ConstantKeys.kExpirationDate) as? Date
    }
    
    private var shouldRefreshToken : Bool {
        guard let expirationDate = tokenExpirationDate else { return false}
        let fiveMinutes : TimeInterval = 300
        return Date().addingTimeInterval(fiveMinutes) >= expirationDate
    }
    
    private init(){}
    
    public func exchangeCodeForToken(code: String, completion: @escaping (Bool) -> Void){
        guard let urlToken = URL(string: Constants.tokenAPIURL) else { return }
        var components = URLComponents()
        components.queryItems =
        [
            URLQueryItem(name: "grant_type", value: "authorization_code"),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectUri?.absoluteString)
        ]
        var request = URLRequest(url: urlToken)
        request.httpMethod = "POST"
        request.httpBody = components.query?.data(using: .utf8)
        guard let basicToken = Constants.basicToken else {
            print("faluere to getn base64")
           completion(false)
            return
        }
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("Basic \(basicToken)", forHTTPHeaderField: "Authorization")
        
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            guard let data = data, error == nil else {
               completion(false)
                return
                
            }
            
            do {
                let result = try JSONDecoder().decode(AuthResponce.self, from: data)
                self?.cacheToken(result: result)
                completion(true)
            } catch {
                print(error.localizedDescription)
                completion(false)
               
            }
        }
        
        task.resume()
    

    }
    
    private func cacheToken(result : AuthResponce){
        UserDefaults.standard.set(result.accessToken, forKey: ConstantKeys.kAccessToken)
        UserDefaults.standard.set(Date().addingTimeInterval(TimeInterval(result.expiresIn)), forKey: ConstantKeys.kExpirationDate)
        if let refreshToken = result.refreshToken {
            UserDefaults.standard.set(refreshToken, forKey: ConstantKeys.kRefreshToken)
        }
        UserDefaults.standard.set(result.tokenType, forKey: ConstantKeys.kTokenType)
        
    }
    
     func refreshIfNeeded(completion: @escaping (Bool) -> Void){
//        guard shouldRefreshToken else {
//            completion(true)
//            return
//            
//        }
        guard let refreshToken = refreshToken else {
            return
        }
        
        guard let urlToken = URL(string: Constants.tokenAPIURL) else { return }
        var components = URLComponents()
        components.queryItems =
        [
            URLQueryItem(name: "grant_type", value: "refresh_token"),
            URLQueryItem(name: "refresh_token", value: refreshToken)
        ]
        var request = URLRequest(url: urlToken)
        request.httpMethod = "POST"
        request.httpBody = components.query?.data(using: .utf8)
        guard let basicToken = Constants.basicToken else {
            print("faluere to getn base64")
           completion(false)
            return
        }
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("Basic \(basicToken)", forHTTPHeaderField: "Authorization")
        
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            guard let data = data, error == nil else {
               completion(false)
                return
                
            }
            
            do {
                let result = try JSONDecoder().decode(AuthResponce.self, from: data)
                print("Success: \(result)")
                self?.cacheToken(result: result)
                completion(true)
            } catch {
                print(error.localizedDescription)
                completion(false)
               
            }
        }
        
        task.resume()
    }
        

    }
    
