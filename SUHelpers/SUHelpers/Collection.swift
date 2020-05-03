//
//  Collection.swift
//  SUHelpers
//
//  Created by Alex Nikolenko on 03/05/2020.
//  Copyright © 2020 Artem Trubacheev. All rights reserved.
//

public extension Collection {

    subscript(safe index: Index) -> Element? {
        return self.indices.contains(index) ? self[index] : nil
    }

}
