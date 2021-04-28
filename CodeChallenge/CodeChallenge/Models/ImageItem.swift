//
//  ImageItem.swift
//  CodeChallenge
//
//  Created by Cesar Brenes on 19/2/21.
//

import Foundation

struct ImageItem: Codable {
    var id: Int
    var url: String
    var thumbnailUrl: String
    
    enum CodingKeys: String, CodingKey {
        case id, url, thumbnailUrl
    }
}

extension ImageItem {
    init() {
        id = 0
        url = ""
        thumbnailUrl = ""
    }
}
