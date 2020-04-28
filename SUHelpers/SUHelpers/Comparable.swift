//
//  Comparable.swift
//  SUHelpers
//
//  Created by Alex Nikolenko on 28/04/2020.
//  Copyright © 2020 Artem Trubacheev. All rights reserved.
//

import Foundation

extension Comparable {

    public func inRange(of range: ClosedRange<Self>) -> Self {
        return min(max(range.lowerBound, self), range.upperBound)
    }

}
