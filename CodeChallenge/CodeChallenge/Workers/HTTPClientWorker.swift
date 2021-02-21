//
//  HTTPClientWorker.swift
//  CodeChallenge
//
//  Created by Cesar Brenes on 20/2/21.
//

import Foundation

/**
    This class allows to use mock data when we are using URSession, Check the file called CustomImageViewWithCacheTests.swift to the implementation
 */

protocol URLSessionProtocol {
    func dataTaskWithURL(with url: URL, completionHandler: @escaping(Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol
}

class HTTPClientWorker {
    let session: URLSessionProtocol

    init(session: URLSessionProtocol) {
        self.session = session
    }
    
    func dataTask(with url: URL, completionHandler: @escaping(Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        return session.dataTaskWithURL(with: url, completionHandler: completionHandler)
    }
}

extension URLSession: URLSessionProtocol {
    func dataTaskWithURL(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        dataTask(with: url, completionHandler: completionHandler) as URLSessionDataTaskProtocol
    }
}

protocol URLSessionDataTaskProtocol {
    func resume()
    func cancel()
}

extension URLSessionDataTask: URLSessionDataTaskProtocol { }
