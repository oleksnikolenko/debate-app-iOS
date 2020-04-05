//
//  With.swift
//  SUHelpers
//
//  Created by Artem Trubacheev on 26.01.2020.
//  Copyright © 2020 Artem Trubacheev. All rights reserved.
//

import Foundation

public extension NSObjectProtocol {

    func with(_ closure: (Self) -> Void) -> Self {
        closure(self)
        return self
    }

}
