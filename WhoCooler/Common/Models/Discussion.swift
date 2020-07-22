//
//  Discussion.swift
//  WhoCooler
//
//  Created by Artem Trubacheev on 26.01.2020.
//  Copyright © 2020 Artem Trubacheev. All rights reserved.
//

struct Debate: Decodable {
    let id: String
    var leftSide: DiscussionSide
    var rightSide: DiscussionSide
    let category: Category
    let votesCount: Int
    var messagesList: MessagesList
    var isFavorite: Bool
    var messageCount: Int
    let name: String?
    let image: String?
    let type: String

    enum CodingKeys: String, CodingKey {
        case id
        case leftSide = "leftside"
        case rightSide = "rightside"
        case messagesList = "message_list"
        case votesCount = "votes_count"
        case category
        case isFavorite = "is_favorite"
        case messageCount = "message_count"
        case name
        case image
        case type
    }
}

extension Debate {

    var totalVotes: Int {
        leftSide.ratingCount + rightSide.ratingCount
    }

    var leftSidePercents: Int {
        Int((Double(leftSide.ratingCount) / Double(totalVotes)) * 100)
    }

    var rightSidePercents: Int {
        100 - leftSidePercents
    }

    var debateType: DebateType {
        return DebateType(type)
    }

}

enum DebateType {
    case sides
    case statement

    init(_ type: String) {
        switch type {
        case "sides":
            self = .sides
        case "statement":
            self = .statement
        default:
            self = .sides
        }
    }
}
