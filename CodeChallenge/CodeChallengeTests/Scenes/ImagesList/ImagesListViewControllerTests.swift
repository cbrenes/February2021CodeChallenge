//
//  ImagesListViewControllerTests.swift
//  CodeChallengeTests
//
//  Created by Cesar Brenes on 19/2/21.
//

import XCTest
@testable import CodeChallenge

class ImagesListViewControllerTests: XCTestCase {
    
    var viewController: ImagesListViewController!
    var window: UIWindow!
    
    override func setUpWithError() throws {
        window = UIWindow()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let viewController = storyboard.instantiateViewController(withIdentifier: String(describing: ImagesListViewController.self)) as? ImagesListViewController {
            self.viewController = viewController
        }
    }
    
    func loadView() {
        window.addSubview(viewController.view)
        RunLoop.current.run(until: Date())
    }
    
    class ImagesListBusinessLogicSpy: ImagesListBusinessLogic {
        
        var requestDataSourceWasCalled = false
        
        var requestDataSource: ImagesList.DataSource.Request?
        
        func requestDataSource(request: ImagesList.DataSource.Request) {
            requestDataSourceWasCalled = true
            requestDataSource = request
        }
    }
    
    func testRequestDataSourceShouldHappenWhenViewDidLoadIsCalled() throws {
        let interactor = ImagesListBusinessLogicSpy()
        viewController.interactor = interactor
        loadView()
        
        viewController.viewDidLoad()
        
        XCTAssert(interactor.requestDataSourceWasCalled)
        XCTAssertFalse(interactor.requestDataSource?.isRefreshAction ?? true)
    }
    
    func testRequestDataSourceShouldHappenWhenRefreshIsCalled() throws {
        let interactor = ImagesListBusinessLogicSpy()
        viewController.interactor = interactor
        loadView()
        
        viewController.refresh(self)
        
        XCTAssert(interactor.requestDataSourceWasCalled)
        XCTAssert(interactor.requestDataSource?.isRefreshAction ?? false)
    }
    
    func testViewDidLoadShouldRegisterCustomCells() throws {
        let interactor = ImagesListBusinessLogicSpy()
        viewController.interactor = interactor
        loadView()
        
        let tableView = TableViewSpy()
        viewController.tableView = tableView
        viewController.viewDidLoad()
        
        XCTAssert(tableView.registerForCellReuseIdentifierWasCalled)
    }
    
    func testDisplayDataSourceShouldReloadTableViewIfDoesntHavePreviousData() {
        let interactor = ImagesListBusinessLogicSpy()
        viewController.interactor = interactor
        loadView()
        
        let tableView = TableViewSpy()
        viewController.tableView = tableView
        
        viewController.displayDataSourceSuccess(viewModel: ImagesList.DataSource.ViewModel.Succes(numberOfPreviousItems: 0, displayObjects: [ImagesList.DataSource.ViewModel.Succes.DisplayObject(thumbnailUrl: nil)], totalNumberOfElements: 2, indexPathToInsert: nil))
        
        XCTAssert(tableView.reloadDataCalled)
    }
    
    func testNumberOfSectionsInTheTableShouldBeEqualToNumberOfSectionsToDisplay()  throws {
        let interactor = ImagesListBusinessLogicSpy()
        viewController.interactor = interactor
        loadView()
        
        viewController.displayDataSourceSuccess(viewModel: ImagesList.DataSource.ViewModel.Succes(numberOfPreviousItems: 0, displayObjects: [ImagesList.DataSource.ViewModel.Succes.DisplayObject(thumbnailUrl: nil)], totalNumberOfElements: 10, indexPathToInsert: nil))
        let numberOfSections = viewController.tableView.numberOfSections
        
        XCTAssertEqual(numberOfSections, 1)
    }
    
    func testNumberOfItemsPerSectionInTheTableShouldBeEqualToTheNumberOfRowsPerSectionToDisplay() throws {
        let interactor = ImagesListBusinessLogicSpy()
        viewController.interactor = interactor
        loadView()
        let totalNumberOfElements = 10
        
        viewController.displayDataSourceSuccess(viewModel: ImagesList.DataSource.ViewModel.Succes(numberOfPreviousItems: 0, displayObjects: [ImagesList.DataSource.ViewModel.Succes.DisplayObject(thumbnailUrl: nil)], totalNumberOfElements: totalNumberOfElements, indexPathToInsert: nil))
        let numberOfRows = viewController.tableView(viewController.tableView, numberOfRowsInSection: 0)
        
        XCTAssertEqual(numberOfRows, totalNumberOfElements)
    }
    
    func testCellForRowAtDisplayStartsProcesToDownloadImage() throws {
        let interactor = ImagesListBusinessLogicSpy()
        viewController.interactor = interactor
        loadView()
        let totalNumberOfElements = 10
        let urlString = "https://via.placeholder.com/150/1ee8a4"
        
        viewController.displayDataSourceSuccess(viewModel: ImagesList.DataSource.ViewModel.Succes(numberOfPreviousItems: 0, displayObjects: [ImagesList.DataSource.ViewModel.Succes.DisplayObject(thumbnailUrl: URL(string: urlString))], totalNumberOfElements: totalNumberOfElements, indexPathToInsert: nil))
        let cell = viewController.tableView(viewController.tableView, cellForRowAt: IndexPath(item: 0, section: 0)) as! ImageListTableViewCell
        
        XCTAssertNotNil(cell.thumbnailImageView.dataTask)
    }
    
    func testDisplayEmptyMessageChangeTheStyleOfTheTableView() throws {
        let interactor = ImagesListBusinessLogicSpy()
        viewController.interactor = interactor
        loadView()
        let emptyTest = "test test test"
        viewController.displayDataSourceEmptyState(viewModel: ImagesList.DataSource.ViewModel.EmptyState(message: emptyTest))
        
        XCTAssertNotNil(viewController.tableView.backgroundView)
        if let messageLabel = viewController.tableView.backgroundView?.viewWithTag(-9897) as? UILabel {
            XCTAssertEqual(messageLabel.text, emptyTest)
        } else {
            XCTAssert(false)
        }
    }
    
    func testWhenErrorAlertControllerIsShowedAndTheUserPressesTheRetryButtonTheCodeShouldExecuteTheRequestDataSourceMethod() throws {
        let interactor = ImagesListBusinessLogicSpy()
        viewController.interactor = interactor
        viewController.actionInstance = MockAlertAction.self
        loadView()
        
        viewController?.displayDataSourceErrorFound(viewModel: ImagesList.DataSource.ViewModel.ErrorFound(title: "title", message: "message", leftButtonTitle: "leftButtonTitle", rightButtonTitle: "rightButtonTitle", tableViewErrorMessage: "tableViewErrorMessage"))
        
        let mockAlertController = viewController.presentedViewController as! UIAlertController
        let action = mockAlertController.actions[1] as! MockAlertAction
        
        XCTAssertEqual(action.mockTitle, "rightButtonTitle")
        XCTAssert(interactor.requestDataSourceWasCalled)
        XCTAssertFalse(interactor.requestDataSource?.isRefreshAction ?? true)
    }
    
    func testWhenErrorAlertControllerIsShowedAndTheUserPressesTheCancelButtonShouldntCallTheRequestDataSource() throws {
        let interactor = ImagesListBusinessLogicSpy()
        viewController.interactor = interactor
        viewController.actionInstance = MockAlertAction.self
        loadView()
        
        viewController?.displayDataSourceErrorFound(viewModel: ImagesList.DataSource.ViewModel.ErrorFound(title: "title", message: "message", leftButtonTitle: "leftButtonTitle", rightButtonTitle: "rightButtonTitle", tableViewErrorMessage: "tableViewErrorMessage"))
        interactor.requestDataSource = nil
        interactor.requestDataSourceWasCalled = false
        let mockAlertController = viewController.presentedViewController as! UIAlertController
        let action = mockAlertController.actions[0] as! MockAlertAction
        
        XCTAssertEqual(action.mockTitle, "leftButtonTitle")
        XCTAssertFalse(interactor.requestDataSourceWasCalled)
        XCTAssertNil(interactor.requestDataSource)
    }
}



