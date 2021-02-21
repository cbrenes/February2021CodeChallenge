//
//  LocalizationHelper.swift
//  CodeChallenge
//
//  Created by Cesar Brenes on 21/2/21.
//

import Foundation

enum LocalizationHelper: String {
    case youDontHaveAnyPhotosYet = "You don't have any photos yet"
    case photos = "Photos"
    case photoDetail = "Photo Detail"
    case errorFound = "Error Found"
    case noInternetConnectionMakeSureThatWifiOrMobileDataIsTurnedONThenTryAgain = "No internet connection, Make sure that Wi-Fi or mobile data is turned on, then try again."
    case retry = "Retry"
    case cancel = "Cancel"
    case serverError = "Server Error"
    case aProblemOcurredPleaseTryAPullDownToRefresh = "A problem ocurred, please try a pull down to refresh"
 
    func localizedString() -> String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
}
