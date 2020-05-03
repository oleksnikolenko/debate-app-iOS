//
//  Message.swift
//  DiscussionMaker
//
//  Created by Artem Trubacheev on 11.04.2020.
//  Copyright © 2020 Artem Trubacheev. All rights reserved.
//

import SUHelpers

class Message: Decodable, Equatable {

    let id: String
    let createdTime: Double
    let user: User
    let text: String
    var voteCount: Int
    var userVote: String

    enum CodingKeys: String, CodingKey {
        case id
        case createdTime = "created_time"
        case user
        case text
        case voteCount = "vote_count"
        case userVote = "user_vote"
    }

    static func == (lhs: Message, rhs: Message) -> Bool {
        lhs.id == rhs.id
    }

}

extension Message: Votable {

    var voteType: VoteType { VoteType(userVote) }
    var objectId: String { id }
    var votesCount: Int { voteCount }

    func setVoteType(_ voteType: VoteType) {
        userVote = voteType.rawValue
    }

    func didVote(voteModel: VoteModel, voteType: VoteType) {
        voteCount = voteModel.voteCount
    }

    func vote(_ voteType: VoteType) {
        userVote = voteType.rawValue
    }

}
