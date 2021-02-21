//
//  ImagesListPresenterTests.swift
//  CodeChallengeTests
//
//  Created by Cesar Brenes on 19/2/21.
//

import XCTest
@testable import CodeChallenge

class ImagesListPresenterTests: XCTestCase {
    
    var presenter: ImagesListPresenter!
    
    override func setUpWithError() throws {
        presenter = ImagesListPresenter()
    }
    
    class ImagesListDisplayLogicSpy: ImagesListDisplayLogic {
        
        var displayDataSourceSuccessWasCalled = false
        var displayDataSourceErrorFoundWasCalled = false
        var displayDataSourceEmptyStateWasCalled = false
        
        var displayDataSourceSuccessViewModel: ImagesList.DataSource.ViewModel.Succes?
        var displayDataSourceEmptyStateViewModel: ImagesList.DataSource.ViewModel.EmptyState?
        var displayDataSourceErrorFoundViewModel: ImagesList.DataSource.ViewModel.ErrorFound?
        
        func displayDataSourceSuccess(viewModel: ImagesList.DataSource.ViewModel.Succes) {
            displayDataSourceSuccessWasCalled = true
            displayDataSourceSuccessViewModel = viewModel
        }
        
        func displayDataSourceErrorFound(viewModel: ImagesList.DataSource.ViewModel.ErrorFound) {
            displayDataSourceErrorFoundWasCalled = true
            displayDataSourceErrorFoundViewModel = viewModel
        }
        
        func displayDataSourceEmptyState(viewModel: ImagesList.DataSource.ViewModel.EmptyState) {
            displayDataSourceEmptyStateWasCalled = true
            displayDataSourceEmptyStateViewModel = viewModel
        }
    }
    
    func testPresentDataSourceShouldAskTheViewControllerToDisplayInfoSuccessWithDataCase() throws {
        let viewController = ImagesListDisplayLogicSpy()
        presenter.viewController = viewController
        let item = ImageItem(id: 1, url: "https://via.placeholder.com/600/323599", thumbnailUrl: "https://via.placeholder.com/150/323599")
        
        presenter?.presentDataSource(response: ImagesList.DataSource.Response(numberOfPreviousItems: 0, items: [item], totalNumberOfElements: 2, errorFound: nil))
        
        XCTAssert(viewController.displayDataSourceSuccessWasCalled)
        XCTAssertFalse(viewController.displayDataSourceErrorFoundWasCalled)
        XCTAssertFalse(viewController.displayDataSourceEmptyStateWasCalled)
        XCTAssertEqual(URL(string: item.thumbnailUrl), viewController.displayDataSourceSuccessViewModel?.displayObjects.first?.thumbnailUrl)
    }
    
    func testPresentDataSourceShouldAskTheViewControllerToDisplayInfoSuccessWithEmptyDataCase() throws {
        let viewController = ImagesListDisplayLogicSpy()
        presenter.viewController = viewController
        
        presenter?.presentDataSource(response: ImagesList.DataSource.Response(numberOfPreviousItems: 0, items: nil, totalNumberOfElements: 0, errorFound: nil))
        
        XCTAssert(viewController.displayDataSourceEmptyStateWasCalled)
        XCTAssertFalse(viewController.displayDataSourceErrorFoundWasCalled)
        XCTAssertFalse(viewController.displayDataSourceSuccessWasCalled)
        XCTAssertEqual(LocalizationHelper.youDontHaveAnyPhotosYet.localizedString(), viewController.displayDataSourceEmptyStateViewModel?.message)
    }
    
    func testPresentDataSourceShouldAskTheViewControllerToDisplayInfoSuccessWithPreviousDataCase() throws {
        let viewController = ImagesListDisplayLogicSpy()
        presenter.viewController = viewController
        let item = ImageItem(id: 1, url: "https://via.placeholder.com/600/323599", thumbnailUrl: "https://via.placeholder.com/150/323599")
        
        presenter?.presentDataSource(response: ImagesList.DataSource.Response(numberOfPreviousItems: 10, items: [item], totalNumberOfElements: 12, errorFound: nil))
        
        XCTAssert(viewController.displayDataSourceSuccessWasCalled)
        XCTAssertFalse(viewController.displayDataSourceErrorFoundWasCalled)
        XCTAssertFalse(viewController.displayDataSourceEmptyStateWasCalled)
        XCTAssertEqual(URL(string: item.thumbnailUrl), viewController.displayDataSourceSuccessViewModel?.displayObjects.first?.thumbnailUrl)
        XCTAssertNotNil(viewController.displayDataSourceSuccessViewModel?.indexPathToInsert)
    }
    
    
    func testPresentDataSourceShouldAskTheViewControllerToDisplayInternetErrorFound() throws {
        let viewController = ImagesListDisplayLogicSpy()
        presenter.viewController = viewController
        let error = NSError(domain: "error", code: NSURLErrorNotConnectedToInternet, userInfo: nil)
        
        presenter?.presentDataSource(response: ImagesList.DataSource.Response(numberOfPreviousItems: 0, items: nil, totalNumberOfElements: 0, errorFound: .networkError(error)))
        
        XCTAssert(viewController.displayDataSourceErrorFoundWasCalled)
        XCTAssertFalse(viewController.displayDataSourceEmptyStateWasCalled)
        XCTAssertFalse(viewController.displayDataSourceSuccessWasCalled)
        XCTAssertEqual(LocalizationHelper.errorFound.localizedString(), viewController.displayDataSourceErrorFoundViewModel?.title)
        XCTAssertEqual(LocalizationHelper.noInternetConnectionMakeSureThatWifiOrMobileDataIsTurnedONThenTryAgain.localizedString(), viewController.displayDataSourceErrorFoundViewModel?.message)
        XCTAssertEqual(LocalizationHelper.cancel.localizedString(), viewController.displayDataSourceErrorFoundViewModel?.leftButtonTitle)
        XCTAssertEqual(LocalizationHelper.retry.localizedString(), viewController.displayDataSourceErrorFoundViewModel?.rightButtonTitle)
        XCTAssertEqual(LocalizationHelper.aProblemOcurredPleaseTryAPullDownToRefresh.localizedString(), viewController.displayDataSourceErrorFoundViewModel?.tableViewErrorMessage)
    }
    
    func testPresentDataSourceShouldAskTheViewControllerToDisplayServerErrorWithNetworkErrorType() throws {
        let viewController = ImagesListDisplayLogicSpy()
        presenter.viewController = viewController
        let error = NSError(domain: "error", code: 74653, userInfo: nil)
        
        presenter?.presentDataSource(response: ImagesList.DataSource.Response(numberOfPreviousItems: 0, items: nil, totalNumberOfElements: 0, errorFound: .networkError(error)))
        
        XCTAssert(viewController.displayDataSourceErrorFoundWasCalled)
        XCTAssertFalse(viewController.displayDataSourceEmptyStateWasCalled)
        XCTAssertFalse(viewController.displayDataSourceSuccessWasCalled)
        XCTAssertEqual(LocalizationHelper.errorFound.localizedString(), viewController.displayDataSourceErrorFoundViewModel?.title)
        XCTAssertEqual(LocalizationHelper.serverError.localizedString(), viewController.displayDataSourceErrorFoundViewModel?.message)
        XCTAssertEqual(LocalizationHelper.cancel.localizedString(), viewController.displayDataSourceErrorFoundViewModel?.leftButtonTitle)
        XCTAssertEqual(LocalizationHelper.retry.localizedString(), viewController.displayDataSourceErrorFoundViewModel?.rightButtonTitle)
        XCTAssertEqual(LocalizationHelper.aProblemOcurredPleaseTryAPullDownToRefresh.localizedString(), viewController.displayDataSourceErrorFoundViewModel?.tableViewErrorMessage)
    }
    
    func testPresentDataSourceShouldAskTheViewControllerToDisplayServerErrorWithJsonParsingErrorType() throws {
        let viewController = ImagesListDisplayLogicSpy()
        presenter.viewController = viewController
        let error = NSError(domain: "error", code: 74653, userInfo: nil)
        
        presenter?.presentDataSource(response: ImagesList.DataSource.Response(numberOfPreviousItems: 0, items: nil, totalNumberOfElements: 0, errorFound: .jsonParsingError(error)))
        
        XCTAssert(viewController.displayDataSourceErrorFoundWasCalled)
        XCTAssertFalse(viewController.displayDataSourceEmptyStateWasCalled)
        XCTAssertFalse(viewController.displayDataSourceSuccessWasCalled)
        XCTAssertEqual(LocalizationHelper.errorFound.localizedString(), viewController.displayDataSourceErrorFoundViewModel?.title)
        XCTAssertEqual(LocalizationHelper.serverError.localizedString(), viewController.displayDataSourceErrorFoundViewModel?.message)
        XCTAssertEqual(LocalizationHelper.cancel.localizedString(), viewController.displayDataSourceErrorFoundViewModel?.leftButtonTitle)
        XCTAssertEqual(LocalizationHelper.retry.localizedString(), viewController.displayDataSourceErrorFoundViewModel?.rightButtonTitle)
        XCTAssertEqual(LocalizationHelper.aProblemOcurredPleaseTryAPullDownToRefresh.localizedString(), viewController.displayDataSourceErrorFoundViewModel?.tableViewErrorMessage)
    }
    
    func testPresentDataSourceShouldAskTheViewControllerToDisplayServerErrorWithInvalidStatusCodeErrorType() throws {
        let viewController = ImagesListDisplayLogicSpy()
        presenter.viewController = viewController
        
        presenter?.presentDataSource(response: ImagesList.DataSource.Response(numberOfPreviousItems: 0, items: nil, totalNumberOfElements: 0, errorFound: .invalidStatusCode(0)))
        
        XCTAssert(viewController.displayDataSourceErrorFoundWasCalled)
        XCTAssertFalse(viewController.displayDataSourceEmptyStateWasCalled)
        XCTAssertFalse(viewController.displayDataSourceSuccessWasCalled)
        XCTAssertEqual(LocalizationHelper.errorFound.localizedString(), viewController.displayDataSourceErrorFoundViewModel?.title)
        XCTAssertEqual(LocalizationHelper.serverError.localizedString(), viewController.displayDataSourceErrorFoundViewModel?.message)
        XCTAssertEqual(LocalizationHelper.cancel.localizedString(), viewController.displayDataSourceErrorFoundViewModel?.leftButtonTitle)
        XCTAssertEqual(LocalizationHelper.retry.localizedString(), viewController.displayDataSourceErrorFoundViewModel?.rightButtonTitle)
        XCTAssertEqual(LocalizationHelper.aProblemOcurredPleaseTryAPullDownToRefresh.localizedString(), viewController.displayDataSourceErrorFoundViewModel?.tableViewErrorMessage)
    }
    
    func testPresentDataSourceShouldAskTheViewControllerToDisplayServerErrorWithInvalidURLErrorType() throws {
        let viewController = ImagesListDisplayLogicSpy()
        presenter.viewController = viewController
        
        presenter?.presentDataSource(response: ImagesList.DataSource.Response(numberOfPreviousItems: 0, items: nil, totalNumberOfElements: 0, errorFound: .invalidURL))
        
        XCTAssert(viewController.displayDataSourceErrorFoundWasCalled)
        XCTAssertFalse(viewController.displayDataSourceEmptyStateWasCalled)
        XCTAssertFalse(viewController.displayDataSourceSuccessWasCalled)
        XCTAssertEqual(LocalizationHelper.errorFound.localizedString(), viewController.displayDataSourceErrorFoundViewModel?.title)
        XCTAssertEqual(LocalizationHelper.serverError.localizedString(), viewController.displayDataSourceErrorFoundViewModel?.message)
        XCTAssertEqual(LocalizationHelper.cancel.localizedString(), viewController.displayDataSourceErrorFoundViewModel?.leftButtonTitle)
        XCTAssertEqual(LocalizationHelper.retry.localizedString(), viewController.displayDataSourceErrorFoundViewModel?.rightButtonTitle)
        XCTAssertEqual(LocalizationHelper.aProblemOcurredPleaseTryAPullDownToRefresh.localizedString(), viewController.displayDataSourceErrorFoundViewModel?.tableViewErrorMessage)
    }
    
    func testPresentDataSourceShouldAskTheViewControllerToDisplayServerErrorWithPaginationErrorType() throws {
        let viewController = ImagesListDisplayLogicSpy()
        presenter.viewController = viewController
        
        presenter?.presentDataSource(response: ImagesList.DataSource.Response(numberOfPreviousItems: 0, items: nil, totalNumberOfElements: 0, errorFound: .paginationError))
        
        XCTAssert(viewController.displayDataSourceErrorFoundWasCalled)
        XCTAssertFalse(viewController.displayDataSourceEmptyStateWasCalled)
        XCTAssertFalse(viewController.displayDataSourceSuccessWasCalled)
        XCTAssertEqual(LocalizationHelper.errorFound.localizedString(), viewController.displayDataSourceErrorFoundViewModel?.title)
        XCTAssertEqual(LocalizationHelper.serverError.localizedString(), viewController.displayDataSourceErrorFoundViewModel?.message)
        XCTAssertEqual(LocalizationHelper.cancel.localizedString(), viewController.displayDataSourceErrorFoundViewModel?.leftButtonTitle)
        XCTAssertEqual(LocalizationHelper.retry.localizedString(), viewController.displayDataSourceErrorFoundViewModel?.rightButtonTitle)
        XCTAssertEqual(LocalizationHelper.aProblemOcurredPleaseTryAPullDownToRefresh.localizedString(), viewController.displayDataSourceErrorFoundViewModel?.tableViewErrorMessage)
    }

    func testCreateIndexPathListToInsertWithPreviousItems() throws {
        let items = [ImageItem(), ImageItem(), ImageItem(), ImageItem(), ImageItem()]
        let numberOfPreviousItems = 10
        let response = ImagesList.DataSource.Response(numberOfPreviousItems: numberOfPreviousItems, items: items , totalNumberOfElements: 16, errorFound: nil)
        
        let result = presenter.createIndexPathListToInsert(response: response)!
        
        XCTAssertEqual(result.count, items.count)
        for (index, indexPath) in result.enumerated() {
            XCTAssertEqual(indexPath.row, index + numberOfPreviousItems)
        }
    }
    
    func testCreateIndexPathListToInsertWithZeroPreviousData() throws {
        let items = [ImageItem(), ImageItem(), ImageItem(), ImageItem(), ImageItem()]
        let numberOfPreviousItems = 0
        let response = ImagesList.DataSource.Response(numberOfPreviousItems: numberOfPreviousItems, items: items , totalNumberOfElements: 16, errorFound: nil)
        
        let result = presenter.createIndexPathListToInsert(response: response)
        
        XCTAssertNil(result)
    }
    
    func testCreateIndexPathListToInsertWithEmptyNewData() throws {
        let numberOfPreviousItems = 10
        let response = ImagesList.DataSource.Response(numberOfPreviousItems: numberOfPreviousItems, items: nil , totalNumberOfElements: 16, errorFound: nil)
        
        let result = presenter.createIndexPathListToInsert(response: response)
        
        XCTAssertNil(result)
    }
}
