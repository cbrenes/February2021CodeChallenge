//
//  UIAlertActionHelper.swift
//  CodeChallenge
//
//  Created by Cesar Brenes on 21/2/21.
//

import UIKit
/**
 This extensions allows to test an alert controller when it's showed
 */
extension UIAlertAction {
    @objc class func makeActionWithTitle(title: String?, style: UIAlertAction.Style, handler: ((UIAlertAction) -> Void)?) -> UIAlertAction {
        return UIAlertAction(title: title, style: style, handler: handler)
    }
}
