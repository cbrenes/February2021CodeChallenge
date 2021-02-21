//
//  Throwable.swift
//  CodeChallenge
//
//  Created by Cesar Brenes on 19/2/21.
//

import Foundation
/**
 his enum is neccesary to avoid issues if the json file has a wrong structure, for example the app is expecting a list of elements but not all the list has the correct format, this code allows to ignore the bad format and present only the data that has the correct format
 */

enum Throwable<T: Decodable>: Decodable {
    case success(T)
    case failure(Error)

    init(from decoder: Decoder) throws {
        do {
            let decoded = try T(from: decoder)
            self = .success(decoded)
        } catch let error {
            self = .failure(error)
        }
    }
}

//This extension helps to get the value of the Throwable object
extension Throwable {
    var value: T? {
        switch self {
        case .failure(_):
            return nil
        case .success(let value):
            return value
        }
    }
}
