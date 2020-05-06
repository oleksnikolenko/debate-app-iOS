//
//  MessagesList.swift
//  WhoCooler
//
//  Created by Artem Trubacheev on 12.04.2020.
//  Copyright © 2020 Artem Trubacheev. All rights reserved.
//

struct MessagesList: Decodable {

    var hasNextPage: Bool
    var messages: [Message]

    enum CodingKeys: String, CodingKey {
        case hasNextPage = "has_next_page"
        case messages
    }

}
