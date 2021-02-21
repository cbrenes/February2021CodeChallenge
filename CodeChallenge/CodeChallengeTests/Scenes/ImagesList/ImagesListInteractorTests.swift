//
//  ImagesListInteractorTests.swift
//  CodeChallengeTests
//
//  Created by Cesar Brenes on 19/2/21.
//

import XCTest
@testable import CodeChallenge

class ImagesListInteractorTests: XCTestCase {
    
    var interactor: ImagesListInteractor!

    override func setUpWithError() throws {
        interactor = ImagesListInteractor()
        interactor.worker = APIWorker(store: MockAPI())
    }

    class ImagesListPresentationLogicSpy: ImagesListPresentationLogic {
        
        var presentDataSourceWasCalled = false
        var presentDataSourceResponse: ImagesList.DataSource.Response?
        
        func presentDataSource(response: ImagesList.DataSource.Response) {
            presentDataSourceWasCalled = true
            presentDataSourceResponse = response
        }
    }
    
    func testRequestDataSourceShouldAskThePresenterToFormatData() throws {
        let presenter = ImagesListPresentationLogicSpy()
        interactor.presenter = presenter
        
        let request = ImagesList.DataSource.Request(isRefreshAction: false)
        interactor.requestDataSource(request: request)
        
        XCTAssert(presenter.presentDataSourceWasCalled)
    }
    
    func testRequestDataSourceShouldUsePagination() throws {
        let presenter = ImagesListPresentationLogicSpy()
        interactor.presenter = presenter
        let currentElements = [ImageItem(), ImageItem(), ImageItem(), ImageItem(), ImageItem()]
        interactor.items = currentElements
        
        let request = ImagesList.DataSource.Request(isRefreshAction: false)
        interactor.requestDataSource(request: request)
        
        XCTAssertEqual(interactor.items.count, currentElements.count + interactor.limitOfElementPerRequest)
        XCTAssertEqual(presenter.presentDataSourceResponse?.numberOfPreviousItems, currentElements.count)
        XCTAssertEqual(presenter.presentDataSourceResponse?.totalNumberOfElements, interactor.items.count + 1)
        XCTAssertNil(presenter.presentDataSourceResponse?.errorFound)
        XCTAssertEqual(presenter.presentDataSourceResponse?.items?.count, interactor.limitOfElementPerRequest)
        XCTAssert(presenter.presentDataSourceWasCalled)
    }
    
    func testRefreshActionShouldRestartItemsArray() throws {
        let presenter = ImagesListPresentationLogicSpy()
        interactor.presenter = presenter
        let currentElements = [ImageItem(), ImageItem(), ImageItem(), ImageItem(), ImageItem()]
        interactor.items = currentElements
        
        let request = ImagesList.DataSource.Request(isRefreshAction: true)
        interactor.requestDataSource(request: request)
        
        XCTAssertEqual(interactor.items.count, interactor.limitOfElementPerRequest)
        XCTAssertEqual(presenter.presentDataSourceResponse?.numberOfPreviousItems, 0)
        XCTAssertEqual(presenter.presentDataSourceResponse?.totalNumberOfElements, interactor.items.count + 1)
        XCTAssertNil(presenter.presentDataSourceResponse?.errorFound)
        XCTAssertEqual(presenter.presentDataSourceResponse?.items?.count, interactor.limitOfElementPerRequest)
        XCTAssert(presenter.presentDataSourceWasCalled)
    }
    
    func testRequestDataSourceDoesntAllowMoreElementsThanTheAPIHas() throws {
        let presenter = ImagesListPresentationLogicSpy()
        interactor.presenter = presenter
        var currentElements = [ImageItem]()
        let limitNumberOfElementsInTheAPI = 5000
        currentElements.append(contentsOf: repeatElement(ImageItem(), count: limitNumberOfElementsInTheAPI))
        interactor.items = currentElements
        
        let request = ImagesList.DataSource.Request(isRefreshAction: false)
        interactor.requestDataSource(request: request)
        
        XCTAssertEqual(interactor.items.count, limitNumberOfElementsInTheAPI)
        XCTAssertEqual(presenter.presentDataSourceResponse?.numberOfPreviousItems, limitNumberOfElementsInTheAPI)
        XCTAssertEqual(presenter.presentDataSourceResponse?.totalNumberOfElements, limitNumberOfElementsInTheAPI)
        XCTAssertNil(presenter.presentDataSourceResponse?.errorFound)
        XCTAssertEqual(presenter.presentDataSourceResponse?.items?.count, 0)
        XCTAssert(presenter.presentDataSourceWasCalled)
    }
    
    func testRequestDataSourceGetTheLastElementsInTheAPI() throws {
        let presenter = ImagesListPresentationLogicSpy()
        interactor.presenter = presenter
        var currentElements = [ImageItem]()
        currentElements.append(contentsOf: repeatElement(ImageItem(), count: 4991))
        interactor.items = currentElements
        
        let request = ImagesList.DataSource.Request(isRefreshAction: false)
        interactor.requestDataSource(request: request)
        
        XCTAssertEqual(interactor.items.count, 5000)
        XCTAssertEqual(presenter.presentDataSourceResponse?.numberOfPreviousItems, 4991)
        XCTAssertEqual(presenter.presentDataSourceResponse?.totalNumberOfElements, 5000)
        XCTAssertNil(presenter.presentDataSourceResponse?.errorFound)
        XCTAssertEqual(presenter.presentDataSourceResponse?.items?.count, 9)
        XCTAssert(presenter.presentDataSourceWasCalled)
    }
    
    func testRequestDataSourceReturnsAndErrorForFirstCall() throws {
        let presenter = ImagesListPresentationLogicSpy()
        interactor.presenter = presenter
        let mockAPiWithErrors = MockAPIWithErrors()
        let error = NSError(domain: "error", code: -10, userInfo: nil)
        mockAPiWithErrors.error = .networkError(error)
        interactor.worker = APIWorker(store: mockAPiWithErrors)
        
        let request = ImagesList.DataSource.Request(isRefreshAction: false)
        interactor.requestDataSource(request: request)
        
        XCTAssert(interactor.items.isEmpty)
        XCTAssertEqual(presenter.presentDataSourceResponse?.numberOfPreviousItems, 0)
        XCTAssertEqual(presenter.presentDataSourceResponse?.totalNumberOfElements, 0)
        XCTAssertNotNil(presenter.presentDataSourceResponse?.errorFound)
        XCTAssertNil(presenter.presentDataSourceResponse?.items)
        XCTAssert(presenter.presentDataSourceWasCalled)
    }
    
    func testRequestDataSourceReturnsAndErrorWhenItHasPreviousData() throws {
        let presenter = ImagesListPresentationLogicSpy()
        interactor.presenter = presenter
        let mockAPiWithErrors = MockAPIWithErrors()
        let error = NSError(domain: "error", code: -10, userInfo: nil)
        mockAPiWithErrors.error = .networkError(error)
        interactor.worker = APIWorker(store: mockAPiWithErrors)
        let currentElements = [ImageItem(), ImageItem(), ImageItem(), ImageItem(), ImageItem()]
        interactor.items = currentElements
        
        let request = ImagesList.DataSource.Request(isRefreshAction: false)
        interactor.requestDataSource(request: request)
        
        XCTAssertEqual(interactor.items.count, currentElements.count)
        XCTAssertEqual(presenter.presentDataSourceResponse?.numberOfPreviousItems, currentElements.count)
        XCTAssertEqual(presenter.presentDataSourceResponse?.totalNumberOfElements, currentElements.count + 1)
        XCTAssertNotNil(presenter.presentDataSourceResponse?.errorFound)
        XCTAssertNil(presenter.presentDataSourceResponse?.items)
        XCTAssert(presenter.presentDataSourceWasCalled)
    }
}
