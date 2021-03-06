//
//  SearchModels.swift
//  WhoCooler
//
//  Created by Alex Nikolenko on 04/05/2020.
//  Copyright © 2020 Artem Trubacheev. All rights reserved.
//

import Foundation

struct SearchResponse: Decodable {

    var debates: [Debate]
    var hasNextPage: Bool

    enum CodingKeys: String, CodingKey {
        case debates
        case hasNextPage = "has_next_page"
    }
}

enum SearchModel {

    struct Request {
        let searchContext: String
        let page: Int
    }

    struct Response {
        let debates: [Debate]
        let hasNextPage: Bool
    }

    struct ViewModel {
        let cells: [CellType]
        let hasNextPage: Bool
    }

    enum CellType {
        case debate(Debate)
    }

}
