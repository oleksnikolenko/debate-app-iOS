//
//  DebatesResponse.swift
//  DiscussionMaker
//
//  Created by Artem Trubacheev on 05.04.2020.
//  Copyright © 2020 Artem Trubacheev. All rights reserved.
//

struct DebatesResponse: Decodable {

    var categories: [Category] = []
    var debates: [Discussion] = []
    var hasNextPage: Bool = false

    enum CodingKeys: String, CodingKey {
        case debates
        case hasNextPage = "has_next_page"
        case categories
    }

}
