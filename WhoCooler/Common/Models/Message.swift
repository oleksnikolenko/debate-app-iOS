//
//  Message.swift
//  WhoCooler
//
//  Created by Artem Trubacheev on 11.04.2020.
//  Copyright © 2020 Artem Trubacheev. All rights reserved.
//

class Message: Decodable, Equatable {

    let id: String
    let createdTime: Double
    let user: User
    let text: String
    var voteCount: Int
    var userVote: String
    var replyList: [Message]
    var replyCount: Int
    let threadId: String?
    var notShownReplyCount: Int

    enum CodingKeys: String, CodingKey {
        case id
        case createdTime = "created_time"
        case threadId = "thread_id"
        case user
        case text
        case voteCount = "vote_count"
        case userVote = "user_vote"
        case replyList = "thread_message_list"
        case replyCount = "thread_message_count"
    }

    static func == (lhs: Message, rhs: Message) -> Bool {
        lhs.id == rhs.id
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(String.self, forKey: .id)
        createdTime = try container.decode(Double.self, forKey: .createdTime)
        user = try container.decode(User.self, forKey: .user)
        text = try container.decode(String.self, forKey: .text)
        voteCount = try container.decode(Int.self, forKey: .voteCount)
        userVote = try container.decode(String.self, forKey: .userVote)
        replyList = try container.decode([Message].self, forKey: .replyList)
        replyCount = try container.decode(Int.self, forKey: .replyCount)
        threadId = try container.decodeIfPresent(String.self, forKey: .threadId)
        notShownReplyCount = try container.decode(Int.self, forKey: .replyCount)
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
