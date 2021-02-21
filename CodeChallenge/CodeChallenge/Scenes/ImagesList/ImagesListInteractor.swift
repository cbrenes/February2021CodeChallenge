//
//  ImagesListInteractor.swift
//  CodeChallenge
//
//  Created by Cesar Brenes on 19/2/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol ImagesListBusinessLogic {
    func requestDataSource(request: ImagesList.DataSource.Request)
}

protocol ImagesListDataStore {
    func getURL(index: Int) -> String?
}
/**
 This class handles the communication between the API service and the other layers, it handles the pagination logic too
 In the case the server is down for some reason we can still using the app making a little change in the worker: var worker = APIWorker(store: MockAPI())
 This will start using a mock api instead of the real server
 */
class ImagesListInteractor: ImagesListBusinessLogic, ImagesListDataStore {
    var presenter: ImagesListPresentationLogic?
    var worker = APIWorker(store: (JsonPlaceHolderService()))
    
    let limitOfElementPerRequest = 20
    var items = [ImageItem]()
    var isFetchInProgress = false // This variable avoids consecutive call the request data to the API
    
    func requestDataSource(request: ImagesList.DataSource.Request) {
        if isFetchInProgress {
            return
        }
        isFetchInProgress = true
        if request.isRefreshAction {
            items.removeAll()
        }
        handleRequestDataSource(request: request)
    }
    
    func getURL(index: Int) -> String? {
        if index < items.count {
            return items[index].url
        }
        return nil
    }
}

extension ImagesListInteractor {
    func handleRequestDataSource(request: ImagesList.DataSource.Request) {
        worker.getData(start: items.count, limit: limitOfElementPerRequest) {[weak self] (itemsFromAPI, error) in
            self?.isFetchInProgress = false
            guard let self = self else {
                return
            }
            let totalNumberOfElements = self.getNumberOfElementsToDisplay(itemsFromApi: itemsFromAPI ?? [ImageItem](), previousItems: self.items, errorFound: error)
            let numberOfPreviousItems = self.items.count
            if let error = error {
                self.presenter?.presentDataSource(response: ImagesList.DataSource.Response(numberOfPreviousItems: self.items.count, items: nil, totalNumberOfElements: totalNumberOfElements, errorFound: error))
                return
            }
            if let itemsFromAPI = itemsFromAPI {
                self.items += itemsFromAPI
            }
            self.presenter?.presentDataSource(response: ImagesList.DataSource.Response(numberOfPreviousItems: numberOfPreviousItems, items: itemsFromAPI, totalNumberOfElements: totalNumberOfElements, errorFound: error))
        }
    }
    
    
    func getNumberOfElementsToDisplay(itemsFromApi: [ImageItem], previousItems: [ImageItem], errorFound: APIError?) -> Int {
        if previousItems.isEmpty && errorFound != nil {
            return 0
        }
        if itemsFromApi.isEmpty && errorFound == nil {
            return previousItems.count
        }
        var valueToKnowIfNeedToGetMoreElements = 1
        if (itemsFromApi.count != limitOfElementPerRequest) && errorFound == nil {
            valueToKnowIfNeedToGetMoreElements = 0
        }
        return itemsFromApi.count + previousItems.count + valueToKnowIfNeedToGetMoreElements
    }
}
