//
//  Enums.swift
//  DiscussionMaker
//
//  Created by Alex Nikolenko on 29/04/2020.
//  Copyright © 2020 Artem Trubacheev. All rights reserved.
//

import Foundation

public enum SideType {
    case left
    case right
}

public enum SideVoteStyle {
    case nonVoted
    case voted
    case singleWinner
}

public enum VoteType: String, Codable {
    case up
    case down
    case none

    init(_ string: String) {
        switch string {
        case "up":
            self = .up
        case "down":
            self = .down
        default:
            self = .none
        }
    }
}

public enum MessageStyle {
    case message
    case reply
}
