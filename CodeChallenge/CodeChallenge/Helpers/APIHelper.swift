//
//  APIHelper.swift
//  CodeChallenge
//
//  Created by Cesar Brenes on 28/4/21.
//

import Foundation


struct APIHelper {
    
    enum Method: String {
        case GET
    }
    
    static func createRequest<T: Codable>(url: String, method: Method, timeOutInterval: Double = 30.0, completionHandler: @escaping((Result<T, APIError>) -> Void)) {
        guard let requestURL = URL(string: url) else {
            completionHandler(.failure(.invalidURL))
            return
        }
        let session = URLSession.shared
        var request = URLRequest(url: requestURL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: timeOutInterval)
        request.httpMethod = method.rawValue
        let task = session.dataTask(with: request, completionHandler: { data, response, error in
            if let error = error {
                completionHandler(.failure(.networkError(error)))
                return
            }
            guard let data = data else {
                completionHandler(.failure(.noData))
                return
            }
            do {
                let decodedAnswer = try JSONDecoder().decode(T.self, from: data)
                completionHandler(.success(decodedAnswer))
            } catch let error {
                completionHandler(.failure(.jsonParsingError(error)))
            }
        })
        task.resume()
    }
}
