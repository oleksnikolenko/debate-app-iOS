//
//  Category.swift
//  WhoCooler
//
//  Created by Alex Nikolenko on 26/04/2020.
//  Copyright © 2020 Artem Trubacheev. All rights reserved.
//

struct Category: Decodable, Equatable {
    let id: String
    let name: String
}

extension Category {

    static var all: Category {
        Category(id: "all", name: "category.all".localized)
    }

    static var favorites: Category {
        Category(id: "favorites", name: "category.favorites".localized)
    }

}
