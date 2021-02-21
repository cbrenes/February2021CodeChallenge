//
//  ImageDetailInteractorTests.swift
//  CodeChallengeTests
//
//  Created by Cesar Brenes on 21/2/21.
//

import XCTest
@testable import CodeChallenge

class ImageDetailInteractorTests: XCTestCase {
    
    var interactor: ImageDetailInteractor!
    
    override func setUpWithError() throws {
        interactor = ImageDetailInteractor()
        interactor.url = "https://via.placeholder.com/600/61a65"
    }
    
    class ImageDetailPresentationLogicSpy: ImageDetailPresentationLogic {
        
        var presentUIInformationWasCalled = false
        func presentUIInformation(response: ImageDetail.UIInformation.Response) {
            presentUIInformationWasCalled = true
        }
    }
    
    func testRequestUIInformationShouldAskThePresenterToFormatData() throws {
        let presenter = ImageDetailPresentationLogicSpy()
        interactor.presenter = presenter
        
        let request = ImageDetail.UIInformation.Request()
        interactor.requestUIInformation(request: request)
        
        XCTAssert(presenter.presentUIInformationWasCalled)
    }
}
