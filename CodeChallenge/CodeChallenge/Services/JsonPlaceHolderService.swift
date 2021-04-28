//
//  JsonPlaceHolderService.swift
//  CodeChallenge
//
//  Created by Cesar Brenes on 19/2/21.
//

import Foundation

struct JsonPlaceHolderService: APIStoreProtocol {
    
    func getData(start: Int, limit: Int, completionHandler: @escaping apiAnswer) {
        APIHelper.createRequest(url: APIConstants.getPhotosURL(start: start, limit: limit), method: .GET, completionHandler: completionHandler)
    }
}
