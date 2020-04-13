//
//  User.swift
//  DiscussionMaker
//
//  Created by Artem Trubacheev on 11.04.2020.
//  Copyright © 2020 Artem Trubacheev. All rights reserved.
//

struct User: Codable, Equatable {

    let id: String
    let name: String

    enum CodingKeys: String, CodingKey {
        case id
        case name = "username"
    }

}
