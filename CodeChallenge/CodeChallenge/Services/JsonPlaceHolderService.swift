//
//  JsonPlaceHolderService.swift
//  CodeChallenge
//
//  Created by Cesar Brenes on 19/2/21.
//

import Foundation

class JsonPlaceHolderService: APIStoreProtocol {
    
    let timeOutInterval = 30.0
    
    func getData(start: Int, limit: Int, completionHandler: @escaping (_ items: [ImageItem]?, _ error: APIError?) -> Void) {
        guard let requestURL = URL(string: APIConstants.getPhotosURL(start: start, limit: limit)) else {
            completionHandler(nil, .invalidURL)
            return
        }
        let session = URLSession.shared
        let request = URLRequest(url: requestURL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: timeOutInterval)
        let task = session.dataTask(with: request, completionHandler: { data, response, error in
            if let error = error {
                completionHandler(nil, .networkError(error))
                return
            }
            guard let data = data else {
                completionHandler(nil, nil)
                return
            }
            do {
                let decodedAnswer = try JSONDecoder().decode([Throwable<ImageItem>].self, from: data)
                completionHandler(decodedAnswer.compactMap { $0.value }, nil)
            } catch let error {
                completionHandler(nil, APIError.jsonParsingError(error as! DecodingError))
            }
        })
        task.resume()
    }
}
