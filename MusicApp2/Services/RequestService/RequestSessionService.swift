//
//  RequestSessionService.swift
//  MusicApp2
//
//  Created by Aleks Kravtsova on 28.06.22.
//

import Foundation
struct RequestSessionService {
 
     func createRequest(with url: URL?,
                               type: HTTPMethods,
                               completion: @escaping (URLRequest)-> Void) {
        
        AuthManager.shared.withValidToken { token in
            guard let apiURL = url else { return }
            var request = URLRequest(url: apiURL)
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.httpMethod = type.rawValue
            request.timeoutInterval = 30
            completion(request)
        }
    }
    
     func createURLSession<T: Decodable>(with request: URLRequest,
                                                       completion: @escaping (Result<T, Error>) -> Void) {
        
       URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(APIError.failedToGetData))
                return
            }
            
            do {
                let result = try JSONDecoder().decode(T.self, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
       }.resume()
        
    
        
    }
}
