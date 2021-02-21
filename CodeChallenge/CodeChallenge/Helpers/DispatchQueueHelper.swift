//
//  DispatchQueueHelper.swift
//  CodeChallenge
//
//  Created by Cesar Brenes on 20/2/21.
//

import Foundation
/**
 This helper allows to run the test using the main thread without need to open a new one, this is helpful to avoid async operations when they aren't necessaries
 */
class DispatchQueueHelper {
    class func executeInMainThread(completion: @escaping () -> Void) {
        if Thread.isMainThread {
            completion()
        } else {
            DispatchQueue.main.async(execute: completion)
        }
    }
}
