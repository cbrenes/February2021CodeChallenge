//
//  UITableView+EmptyStates.swift
//  CodeChallenge
//
//  Created by Cesar Brenes on 21/2/21.
//

import UIKit
/**
 This extensions allows to show a message in a table view, this is very helpful in the cases we need to show an empty state or error message
 */
extension UITableView {

    func setStateMessage(message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.sizeToFit()
        messageLabel.tag = -9897 // This allows to check the correct message in the tests
        self.backgroundView = messageLabel
        self.separatorStyle = .none
        reloadData()
    }

    /**
     This method hides the message showed using the setStateMessage method
     */
    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}
