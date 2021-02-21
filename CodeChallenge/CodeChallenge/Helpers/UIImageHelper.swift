//
//  UIImageHelper.swift
//  CodeChallenge
//
//  Created by Cesar Brenes on 21/2/21.
//

import UIKit

enum ImageHelper: String {
    case imageNotFound = "imageNotFound"
 
    func image() -> UIImage? {
        return UIImage(named: self.rawValue)
    }
}
