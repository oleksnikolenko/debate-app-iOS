//
//  Double.swift
//  SUHelpers
//
//  Created by Alex Nikolenko on 26/04/2020.
//  Copyright © 2020 Artem Trubacheev. All rights reserved.
//

import Foundation

public extension Double {

    var toDate: Date { Date(timeIntervalSince1970: self) }

}
