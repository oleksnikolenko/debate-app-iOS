//
//  Enums.swift
//  DebateMaker
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
        switch self {
        case .popular:
            return "sorting.popular".localized
        case .newest:
            return "sorting.newest".localized
        case .oldest:
            return "sorting.oldest".localized
        }
    }

}

public enum DebateCellStyle {
    case regular
    case search
}

public extension DebateCellStyle {

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

public enum DebateType {
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

public extension DebateType {

    var name: String {
        switch self {
        case .sides:
            return "debate.type.sides".localized
        case .statement:
            return "debate.type.statement".localized
        }
    }

    var debateNamePlaceholder: String {
        switch self {
        case .sides:
            return "debate.name.placeholder".localized
        case .statement:
            return "debate.name.placeholder.required".localized
        }
    }

}
