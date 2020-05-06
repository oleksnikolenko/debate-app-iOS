//
//  Enums.swift
//  DiscussionMaker
//
//  Created by Alex Nikolenko on 29/04/2020.
//  Copyright © 2020 Artem Trubacheev. All rights reserved.
//

import UIKit

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

public extension MessageStyle {

    var objectIdParameterName: String {
        switch self {
        case .message:
            return "message_id"
        case .reply:
            return "thread_id"
        }
    }

}

public enum DebateSorting: String {
    case popular
    case newest
    case oldest
}

public extension DebateSorting {

    var name: String {
        /// TODO: - Localize
        switch self {
        case .popular:
            return "Popular"
        case .newest:
            return "Newest"
        case .oldest:
            return "Oldest"
        }
    }

}

public enum DiscussionCellStyle {
    case regular
    case search
}

public extension DiscussionCellStyle {

    var isInfoViewHidden: Bool {
        switch self {
        case .regular:
            return false
        case .search:
            return true
        }
    }

    var separatorMargin: CGFloat {
        switch self {
        case .regular:
            return 12
        case .search:
            return 16
        }
    }

}
