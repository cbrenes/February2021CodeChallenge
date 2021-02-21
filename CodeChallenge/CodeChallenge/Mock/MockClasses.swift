//
//  MockClasses.swift
//  CodeChallenge
//
//  Created by Cesar Brenes on 20/2/21.
//

import Foundation
import UIKit

/**
 All the classes in this file are using by Unit Tests
 */
class MockURLSession: URLSessionProtocol {
    
    var nextDataTask = MockURLSessionDataTask()
    var dataTaskWithURLWasCalled = false
    var mockData: Data?
    var mockError: Error?
    
    
    func dataTaskWithURL(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        completionHandler(mockData, nil, mockError)
        dataTaskWithURLWasCalled = true
        return nextDataTask
    }
}

class MockURLSessionDataTask: URLSessionDataTaskProtocol {
    var resumeWasCalled = false
    var cancelWasCalled = false
    
    func resume() {
        resumeWasCalled = true
    }
    
    func cancel() {
        cancelWasCalled = true
    }
}

class UIActivityIndicatorViewMock: UIActivityIndicatorView {
    
    var stopAnimatingWasCalled = false
    override func stopAnimating() {
        stopAnimatingWasCalled = true
    }
}

class MockAPIWithErrors: MockAPI {
    
    var error: APIError?
    override func getData(start: Int, limit: Int, completionHandler: @escaping ([ImageItem]?, APIError?) -> Void) {
        completionHandler(nil, error)
    }
}

class TableViewSpy: UITableView {
    
    var reloadDataCalled = false
    var registerForCellReuseIdentifierWasCalled = false
    var setEmptyStateMessageWasCalled = false
    
    override func reloadData() {
        reloadDataCalled = true
    }
    
    override func register(_ nib: UINib?, forCellReuseIdentifier identifier: String) {
        registerForCellReuseIdentifierWasCalled = true
    }
}

class MockAlertAction: UIAlertAction {
    
    typealias Handler = ((UIAlertAction) -> Void)
    var mockHandler: Handler?
    var mockTitle: String?
    var mockStyle: UIAlertAction.Style
    
    convenience init(title: String?, style: UIAlertAction.Style, handler: ((UIAlertAction) -> Void)?) {
        self.init()
        mockTitle = title
        mockStyle = style
        self.mockHandler = handler
    }
    
    override init() {
        mockStyle = .default
        super.init()
    }
    
    override class func makeActionWithTitle(title: String?, style: UIAlertAction.Style, handler: ((UIAlertAction) -> Void)?) -> MockAlertAction {
        return MockAlertAction(title: title, style: style, handler: handler)
    }
}
