//
//  RequestSessionService.swift
//  MusicApp2
//
//  Created by Aleks Kravtsova on 28.06.22.
//

import Foundation
import Combine


class RequestSessionService {
    
    private var cancellables = Set<AnyCancellable>()
 
     func createRequest(with url: URL?,
                               type: HTTPMethods,
                               completion: @escaping (URLRequest) -> Void) {
        
        AuthManager.shared.withValidToken { token in
            guard let apiURL = url else { return }
            var request = URLRequest(url: apiURL)
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.httpMethod = type.rawValue
            request.timeoutInterval = 30
            completion(request)
        }
    }
    
    func createRequest(with url: URL?, type: HTTPMethods) -> Future<URLRequest, Never> {
        return Future { promise in
            AuthManager.shared.withValidToken { token in
                guard let apiURL = url else { return }
                var request = URLRequest(url: apiURL)
                request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
                request.httpMethod = type.rawValue
                request.timeoutInterval = 30
                promise(.success(request))
            }
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
                print(result)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
       }.resume()
        
    
        
    }
    
     func createURLSession<T: Decodable>(with request: URLRequest) -> Future<T, Error> {
        return Future<T, Error> { [weak self] promise in
            guard let self = self else { return }
            URLSession.shared.dataTaskPublisher(for: request)
                .tryMap { (data, response) -> Data in
                    guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
                        throw APIError.failedToGetData
                    }
                    return data
                    
                }
                .decode(type: T.self, decoder: JSONDecoder())
                .sink { completion in
                    if case let .failure(error) = completion {
                        switch error {
                        case let decodingError as DecodingError:
                            promise(.failure(decodingError))
                        case let apiError as APIError:
                            promise(.failure(apiError))
                        default:
                            promise(.failure(APIError.unknown))
                        }
                    }
                } receiveValue: { value in
                    promise(.success(value))
                }
                .store(in: &self.cancellables)


            
        }
  
   }
}
