//
//  VoteModel.swift
//  WhoCooler
//
//  Created by Alex Nikolenko on 30/04/2020.
//  Copyright © 2020 Artem Trubacheev. All rights reserved.
//

import Foundation

struct VoteModel: Codable {

    var voteType: String
    var objectId: String
    var voteCount: Int

    enum CodingKeys: String, CodingKey {
        case voteType = "vote_type"
        case objectId = "object_id"
        case voteCount = "vote_count"
    }

}
