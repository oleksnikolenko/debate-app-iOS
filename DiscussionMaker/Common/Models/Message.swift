//
//  Message.swift
//  DiscussionMaker
//
//  Created by Artem Trubacheev on 11.04.2020.
//  Copyright © 2020 Artem Trubacheev. All rights reserved.
//

struct Message: Decodable {
    let id: String
    let createdTime: Double
    let user: User
    let text: String

    enum CodingKeys: String, CodingKey {
        case id
        case createdTime = "created_time"
        case user
        case text
    }
}
