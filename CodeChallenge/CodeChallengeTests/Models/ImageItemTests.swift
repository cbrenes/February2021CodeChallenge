//
//  ImageItemTests.swift
//  CodeChallengeTests
//
//  Created by Cesar Brenes on 19/2/21.
//

import XCTest
@testable import CodeChallenge

class ImageItemTests: XCTestCase {

    func testParseDataOneElementCorrectData() throws {
        let jsonFile = "[{\"albumId\": 1,\"id\": 1,\"title\": \"accusamus beatae ad facilis cum similique qui sunt\",\"url\": \"https://via.placeholder.com/600/92c952\",\"thumbnailUrl\":\"https://via.placeholder.com/150/92c952\"}]"
        let data = Data(jsonFile.utf8)
        
        let decodedAnswer = try JSONDecoder().decode([ImageItem].self, from: data)
        
        XCTAssertFalse(decodedAnswer.isEmpty)
        XCTAssertEqual(decodedAnswer[0].id, 1)
        XCTAssertEqual(decodedAnswer[0].url, "https://via.placeholder.com/600/92c952")
        XCTAssertEqual(decodedAnswer[0].thumbnailUrl, "https://via.placeholder.com/150/92c952")
    }
    
    func testParseDataOneElementMissingData() throws {
        let jsonFile = "[{\"albumId\": 1,\"id\": 1,\"title\": \"accusamus beatae ad facilis cum similique qui sunt\",\"thumbnailUrl\":\"https://via.placeholder.com/150/92c952\"}]"
        let data = Data(jsonFile.utf8)
        
        let decodedAnswer = try? JSONDecoder().decode([ImageItem].self, from: data)
        
        XCTAssertNil(decodedAnswer)
    }
    
    func testParseDataOneElementCorrectAndOneWithMissingData() throws {
        let jsonFile = "[{\"albumId\": 1,\"id\": 1,\"title\": \"accusamus beatae ad facilis cum similique qui sunt\",\"url\": \"https://via.placeholder.com/600/92c952\",\"thumbnailUrl\":\"https://via.placeholder.com/150/92c952\"}, {\"albumId\": 1,\"id\": 2,\"title\": \"reprehenderit est deserunt velit ipsam\",\"url\": \"https://via.placeholder.com/600/771796\"}]"
        let data = Data(jsonFile.utf8)
        
        let decodedAnswer = try JSONDecoder().decode([Throwable<ImageItem>].self, from: data)
        let imageItems = decodedAnswer.compactMap { $0.value }
        
        
        XCTAssertEqual(imageItems.count, 1)
        XCTAssertEqual(imageItems[0].id, 1)
        XCTAssertEqual(imageItems[0].url, "https://via.placeholder.com/600/92c952")
        XCTAssertEqual(imageItems[0].thumbnailUrl, "https://via.placeholder.com/150/92c952")
    }
    
    func testParseEmptyJson() throws {
        let jsonFile = "{}"
        let data = Data(jsonFile.utf8)
        
        let decodedAnswer = try? JSONDecoder().decode([Throwable<ImageItem>].self, from: data)
        let imageItems = decodedAnswer?.compactMap { $0.value }
        
        XCTAssertNil(imageItems)
    }
}
