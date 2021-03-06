//
//  APIWorker.swift
//  CodeChallenge
//
//  Created by Cesar Brenes on 19/2/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

typealias apiAnswer = (Result<[ImageItem], APIError>) -> Void

protocol APIStoreProtocol {
    func getData(start: Int, limit: Int, completionHandler: @escaping apiAnswer)
}

struct APIWorker {
    var store: APIStoreProtocol
    
    init(store: APIStoreProtocol) {
        self.store = store
    }
    
    func getData(start: Int, limit: Int, completionHandler: @escaping apiAnswer) {
        if start < 0 || limit < 1 {
            completionHandler(.failure(.paginationError))
            return
        }
        store.getData(start: start, limit: limit, completionHandler: completionHandler)
    }
}
