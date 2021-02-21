//
//  ImageDetailPresenterTests.swift
//  CodeChallengeTests
//
//  Created by Cesar Brenes on 21/2/21.
//

import XCTest
@testable import CodeChallenge

class ImageDetailPresenterTests: XCTestCase {
    
    var presenter: ImageDetailPresenter!

    override func setUpWithError() throws {
        presenter = ImageDetailPresenter()
    }
    
    class ImageDetailDisplayLogicSpy: ImageDetailDisplayLogic {
        
        var displayUIInformationWasCalled = false
        func displayUIInformation(viewModel: ImageDetail.UIInformation.ViewModel) {
            displayUIInformationWasCalled = true
        }
    }
    
    func testPresentUIInformationShouldAskTheViewControllerToDisplayInfo() throws {
        let viewController = ImageDetailDisplayLogicSpy()
        presenter.viewController = viewController
        
        presenter?.presentUIInformation(response: ImageDetail.UIInformation.Response(url: "https://via.placeholder.com/600/61a65"))
        
        XCTAssert(viewController.displayUIInformationWasCalled)
    }
}
