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
    let promotionType: String?

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
        case promotionType = "promotion_type"
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

    static func byId(id: String) -> Debate {
        .init(
            id: id,
            leftSide: .init(id: "", name: "", image: nil, ratingCount: 0, isVotedByUser: false),
            rightSide: .init(id: "", name: "", image: nil, ratingCount: 0, isVotedByUser: false),
            category: Category(id: "", name: ""),
            votesCount: 0,
            messagesList: .init(hasNextPage: false, messages: []),
            isFavorite: false,
            messageCount: 0,
            name: nil,
            image: nil,
            type: "",
            promotionType: ""
        )
    }

    var debatePromotionType: DebatePromotionType {
        DebatePromotionType(promotionType)
    }

}
