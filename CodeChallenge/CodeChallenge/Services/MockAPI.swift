//
//  MockAPI.swift
//  CodeChallenge
//
//  Created by Cesar Brenes on 19/2/21.
//

import Foundation

class MockAPI: APIStoreProtocol {
    func getData(start: Int, limit: Int, completionHandler: @escaping (_ items: [ImageItem]?, _ error: APIError?) -> Void) {
        if let path = Bundle.main.path(forResource: "mock", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let decodedAnswer = try JSONDecoder().decode([Throwable<ImageItem>].self, from: data)
                let imageItems = decodedAnswer.compactMap { $0.value }
                completionHandler(splitItemsList(startIndex: start, numberOfElements: limit, items: imageItems), nil)
            } catch(let error) {
                completionHandler(nil, .jsonParsingError(error))
            }
        }
    }
    
    private func splitItemsList(startIndex: Int, numberOfElements: Int, items: [ImageItem]) -> [ImageItem] {
        var chunkList = [ImageItem]()
        var index = startIndex
        while index < items.count && chunkList.count != numberOfElements {
            chunkList.append(items[index])
            index += 1
        }
        return chunkList
    }
    
}

