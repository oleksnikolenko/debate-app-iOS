//
//  DiscussionSide.swift
//  WhoCooler
//
//  Created by Artem Trubacheev on 05.04.2020.
//  Copyright © 2020 Artem Trubacheev. All rights reserved.
//

struct DiscussionSide: Decodable {
    let id: String
    let name: String
    let image: String?
    var ratingCount: Int
    var isVotedByUser: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case image
        case ratingCount = "rating_count"
        case isVotedByUser = "is_voted_by_user"
    }
}
