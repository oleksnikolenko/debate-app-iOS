//
//  Discussion.swift
//  DiscussionMaker
//
//  Created by Artem Trubacheev on 26.01.2020.
//  Copyright © 2020 Artem Trubacheev. All rights reserved.
//

struct Discussion: Decodable {
    let id: String
    let leftSide: DiscussionSide
    let rightSide: DiscussionSide
    var messagesList: MessagesList

    enum CodingKeys: String, CodingKey {
        case id
        case leftSide = "leftside"
        case rightSide = "rightside"
        case messagesList = "message_list"
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

    var name: String {
        "\(leftSide.name) vs \(rightSide.name)"
    }

}
