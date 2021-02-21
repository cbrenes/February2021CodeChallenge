//
//  APIWorkerTests.swift
//  CodeChallengeTests
//
//  Created by Cesar Brenes on 19/2/21.
//

import XCTest
@testable import CodeChallenge

class APIWorkerTests: XCTestCase {
    
    var worker: APIWorker!

    override func setUpWithError() throws {
        worker = APIWorker(store: MockAPI())
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGetDataWithNegativeStartIndex() throws {
        let expect = expectation(description: "wait getData answer")
        var items: [ImageItem]?
        var errorFound: APIError?
        
        worker.getData(start: -10, limit: 10) { (itemsAnwer, error) in
            items = itemsAnwer
            errorFound = error
            expect.fulfill()
        }
        waitForExpectations(timeout: 1, handler: nil)
        
        XCTAssertNil(items)
        XCTAssertEqual(errorFound, .paginationError)
    }
    
    func testGetDataWithNegativeLimitIndex() throws {
        let expect = expectation(description: "wait getData answer")
        var items: [ImageItem]?
        var errorFound: APIError?
        
        worker.getData(start: 10, limit: -10) { (itemsAnwer, error) in
            items = itemsAnwer
            errorFound = error
            expect.fulfill()
        }
        waitForExpectations(timeout: 1, handler: nil)
        
        XCTAssertNil(items)
        XCTAssertEqual(errorFound, .paginationError)
    }
    
    func testGetDataWithNegativeStartAndLimitIndex() throws {
        let expect = expectation(description: "wait getData answer")
        var items: [ImageItem]?
        var errorFound: APIError?
        
        worker.getData(start: -10, limit: -10) { (itemsAnwer, error) in
            items = itemsAnwer
            errorFound = error
            expect.fulfill()
        }
        waitForExpectations(timeout: 1, handler: nil)
        
        XCTAssertNil(items)
        XCTAssertEqual(errorFound, .paginationError)
    }
    
    func testGetDataWithLimitIndexInZero() throws {
        let expect = expectation(description: "wait getData answer")
        var items: [ImageItem]?
        var errorFound: APIError?
        
        worker.getData(start: 10, limit: 0) { (itemsAnwer, error) in
            items = itemsAnwer
            errorFound = error
            expect.fulfill()
        }
        waitForExpectations(timeout: 1, handler: nil)
        
        XCTAssertNil(items)
        XCTAssertEqual(errorFound, .paginationError)
    }
}
