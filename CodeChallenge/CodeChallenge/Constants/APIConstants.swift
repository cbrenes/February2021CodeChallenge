//
//  APIConstants.swift
//  CodeChallenge
//
//  Created by Cesar Brenes on 19/2/21.
//

import Foundation

struct APIConstants {
    static func getPhotosURL(start: Int, limit: Int) -> String {
        return "http://jsonplaceholder.typicode.com/photos?_start=\(start)&_limit=\(limit)"
    }
}
