//
//  Error.swift
//  SUHelpers
//
//  Created by Alex Nikolenko on 09/05/2020.
//  Copyright © 2020 Artem Trubacheev. All rights reserved.
//

import Foundation

public enum ErrorType {
    case unauthorized
    case noInternet
    case unknown
}

public extension Error {

    var type: ErrorType {
        if let error = self as? URLError {
            if error.code == URLError.userAuthenticationRequired {
                return .unauthorized
            } else if error.code == .notConnectedToInternet {
                return .noInternet
            }
        }
        return .unknown
    }

}
