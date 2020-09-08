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
            return "debate.name.placeholder.required".localized
        case .statement:
            return "debate.name.placeholder.required".localized
        }
    }

}

public enum CustdevStyle {
    case contacts
    case text
}

public extension CustdevStyle {

    var isTextViewHidden: Bool {
        switch self {
        case .contacts:
            return true
        case .text:
            return false
        }
    }

    var descriptionText: String {
        switch self {
        case .contacts:
            return "custdev.description".localized
        case .text:
            return "custdev.text.description".localized
        }
    }

    var agreeButtonText: String {
        switch self {
        case .contacts:
            return "custdev.agree".localized
        case .text:
            return "custdev.text.send".localized
        }
    }

    var thankYouText: String {
        switch self {
        case .contacts:
            return "custdev.thanks.contacts".localized
        case .text:
            return "custdev.thanks.text".localized
        }
    }

    var requestParameter: String {
        switch self {
        case .contacts:
            return "contact"
        case .text:
            return "feedback"
        }
    }

}

enum RateAppCellState {
    case initialState
    case likeChosen

    init(state: String?) {
        switch state {
        case "initialState":
            self = .initialState
        case "likeChosen":
            self = .likeChosen
        default:
            self = .initialState
        }
    }

    var title: String {
        switch self {
        case .initialState:
            return "rateapp.doYouLike".localized
        case .likeChosen:
            return "rateapp.thenRateUs".localized
        }
    }

    var agreeButtonText: String? {
        switch self {
        case .initialState:
            return "yes".localized
        case .likeChosen:
            return "rateapp.agree".localized
        }
    }

    var disagreeButtonText: String? {
        switch self {
        case .initialState:
            return "no".localized
        case .likeChosen:
            return "rateapp.noThanks".localized
        }
    }

}
