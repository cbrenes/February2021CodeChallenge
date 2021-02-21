//
//  CustomImageViewWithCacheTests.swift
//  CodeChallengeTests
//
//  Created by Cesar Brenes on 20/2/21.
//

import XCTest
@testable import CodeChallenge

class CustomImageViewWithCacheTests: XCTestCase {
    
    var customImageViewWithCache: CustomImageViewWithCache!
    
    override func setUpWithError() throws {
        customImageViewWithCache = CustomImageViewWithCache()
    }
    
    override func tearDownWithError() throws {
        customImageViewWithCache.imageCache.removeAllObjects()
    }
    
    func testResumeWasCalled() throws {
        let mockURLSession = MockURLSession()
        customImageViewWithCache.httpClient = HTTPClientWorker(session: mockURLSession)
        
        customImageViewWithCache.downloadImage(url: URL(string: "https://via.placeholder.com/600/66b7d2"), imageMode: .scaleAspectFit)
        
        XCTAssert(mockURLSession.nextDataTask.resumeWasCalled)
    }
    
    func testDownloadImageWithError() throws {
        let mockURLSession = MockURLSession()
        let errorFound = NSError(domain: "error", code: -1001, userInfo: nil)
        let expect = expectation(description: "wait to download image")
        let activityIndicatorMock = UIActivityIndicatorViewMock()
        customImageViewWithCache.activityIndicator = activityIndicatorMock
        mockURLSession.mockError = errorFound
        customImageViewWithCache.httpClient = HTTPClientWorker(session: mockURLSession)
        
        if let url = URL(string: "https://via.placeholder.com/600/66b7d2") {
            customImageViewWithCache.downloadImage(url: url, imageMode: .scaleAspectFit, imageNotFound: ImageHelper.imageNotFound.image()) {
                expect.fulfill()
            }
        }
        
        waitForExpectations(timeout: 1, handler: nil)
        
        XCTAssertEqual(customImageViewWithCache.image, ImageHelper.imageNotFound.image())
        XCTAssert(activityIndicatorMock.stopAnimatingWasCalled)
        XCTAssert(mockURLSession.nextDataTask.resumeWasCalled)
    }
    
    func testDownloadImageWithGoodData() throws {
        let mockURLSession = MockURLSession()
        let data =  ImageHelper.imageNotFound.image()?.pngData() ?? Data()
        let expect = expectation(description: "wait to download image")
        let activityIndicatorMock = UIActivityIndicatorViewMock()
        customImageViewWithCache.activityIndicator = activityIndicatorMock
        mockURLSession.mockData = data
        customImageViewWithCache.httpClient = HTTPClientWorker(session: mockURLSession)
        
        if let url = URL(string: "https://via.placeholder.com/600/66b7d2") {
            customImageViewWithCache.downloadImage(url: url, imageMode: .scaleAspectFit, imageNotFound: ImageHelper.imageNotFound.image()) {
                expect.fulfill()
            }
        }
        
        waitForExpectations(timeout: 1, handler: nil)
        
        XCTAssertEqual(customImageViewWithCache.image?.accessibilityIdentifier, "https://via.placeholder.com/600/66b7d2")
        XCTAssert(activityIndicatorMock.stopAnimatingWasCalled)
        XCTAssert(mockURLSession.nextDataTask.resumeWasCalled)
    }
    
    func testImageIsRetrievedFromCache() throws {
        let mockURLSession = MockURLSession()
        let expect = expectation(description: "wait to download image")
        let activityIndicatorMock = UIActivityIndicatorViewMock()
        customImageViewWithCache.activityIndicator = activityIndicatorMock
        customImageViewWithCache.httpClient = HTTPClientWorker(session: mockURLSession)
        
        customImageViewWithCache.imageCache.setObject(ImageHelper.imageNotFound.image() ?? UIImage(), forKey: "https://via.placeholder.com/600/66b7d2")
        if let url = URL(string: "https://via.placeholder.com/600/66b7d2") {
            customImageViewWithCache.downloadImage(url: url, imageMode: .scaleAspectFit, imageNotFound: ImageHelper.imageNotFound.image()) {
                expect.fulfill()
            }
        } else {
            XCTAssert(false, "the url should be valid")
        }
        waitForExpectations(timeout: 1, handler: nil)
        
        XCTAssertEqual(customImageViewWithCache.image?.accessibilityIdentifier, "https://via.placeholder.com/600/66b7d2")
        XCTAssertFalse(mockURLSession.dataTaskWithURLWasCalled)
        XCTAssertFalse(mockURLSession.nextDataTask.resumeWasCalled)
        XCTAssertFalse(mockURLSession.nextDataTask.cancelWasCalled)
    }
}
