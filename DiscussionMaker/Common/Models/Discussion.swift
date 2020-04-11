//
//  Discussion.swift
//  DiscussionMaker
//
//  Created by Artem Trubacheev on 26.01.2020.
//  Copyright © 2020 Artem Trubacheev. All rights reserved.
//

struct Discussion: Decodable {
    let id: String
    let name: String
    let leftSide: DiscussionSide
    let rightSide: DiscussionSide
    let messages: [Message]

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case leftSide = "leftside"
        case rightSide = "rightside"
        case messages
    }
}

extension Discussion {

    var totalVotes: Int {
        leftSide.ratingCount + rightSide.ratingCount
    }

    var leftSidePercents: Int {
        Int((leftSide.ratingCount / totalVotes) * 100)
    }

    var rightSidePercents: Int {
        Int((rightSide.ratingCount / totalVotes) * 100)
    }

}
