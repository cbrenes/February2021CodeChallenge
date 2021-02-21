//
//  ImageDetailViewControllerTests.swift
//  CodeChallengeTests
//
//  Created by Cesar Brenes on 21/2/21.
//

import XCTest
@testable import CodeChallenge

class ImageDetailViewControllerTests: XCTestCase {
    
    var viewController: ImageDetailViewController!
    var window: UIWindow!

    override func setUpWithError() throws {
        window = UIWindow()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let viewController = storyboard.instantiateViewController(withIdentifier: String(describing: ImageDetailViewController.self)) as? ImageDetailViewController {
            self.viewController = viewController
        }
    }

    func loadView() {
        window.addSubview(viewController.view)
        RunLoop.current.run(until: Date())
    }
    
    class ImageDetailBusinessLogicSpy: ImageDetailBusinessLogic {
        
        var requestUIInformationWasCalled = false
        
        func requestUIInformation(request: ImageDetail.UIInformation.Request) {
            requestUIInformationWasCalled = true
        }
    }
    
    func testRequestUIInformationShouldHappenWhenViewDidLoadIsCalled() throws {
        let interactor = ImageDetailBusinessLogicSpy()
        viewController.interactor = interactor
        loadView()
        
        viewController.viewDidLoad()
        
        XCTAssert(interactor.requestUIInformationWasCalled)
    }
    
    func testDisplayUIInformationShouldStartDataTaskRequestInImageView() throws {
        let interactor = ImageDetailBusinessLogicSpy()
        viewController.interactor = interactor
        loadView()
        
        viewController.displayUIInformation(viewModel: ImageDetail.UIInformation.ViewModel(url: URL(string: "https://via.placeholder.com/600/61a65")))
        
        XCTAssertNotNil(viewController.urlImageView.dataTask)
    }
}
