//
//  DebateDetailModels.swift
//  DebateMaker
//
//  Created by Artem Trubacheev on 09.04.2020.
//  Copyright (c) 2020 Artem Trubacheev. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

enum DebateDetail {
    // MARK: Use cases
    enum Initializing {
        struct Request {
            let debate: Debate
        }
        struct Response {
            let debate: Debate
        }
        struct ViewModel {
            let debate: Debate
            let sections: [DebateDetailSection]
        }
    }

    enum SendHandler {
        struct Request {
            let text: String
            let threadId: String?
            let editedMessage: Message?
        }
    }

    enum Vote {
        struct Request {
            let sideId: String
        }
        struct Response {
            let debate: Debate
        }
        struct ViewModel {
            let debate: Debate
        }
    }

    enum MessageSend {
        struct Request {
            let message: String
        }
        struct Response {
            let message: Message
        }
        struct ViewModel {
            let message: Message
        }
    }
    enum ReplySend {
        struct Request {
            let text: String
            let threadId: String
        }
        struct Response {
            let message: Message
            let threadMessage: Message
        }
        struct ViewModel {
            let reply: Message
        }
    }
    enum EditedMessageSend{
        struct Request {
            let messageId: String
            let newText: String
        }
        struct Response {
            let message: Message
        }
        struct ViewModel {
            let message: Message
        }
    }
    enum EditedReplySend {
        struct Request {
            let message: Message
            let newText: String
        }
        struct Response {
            let message: Message
        }
        struct ViewModel {
            let message: Message
        }
    }
    enum DeleteMessage {
        struct Request {
            let message: Message
        }
        struct Response {
            let message: Message
        }
        struct ViewModel {
            let message: Message
        }
    }
    enum DeleteReply {
        struct Request {
            let message: Message
            let threadId: String
        }
        struct Response {
            let message: Message
        }
        struct ViewModel {
            let message: Message
        }
    }
    enum RepliesBatch {
        struct Request {
            let parentMessage: Message
            let index: Int
        }
        struct Response {
            let message: Message
        }
        struct ViewModel {
            let messageId: String
        }
    }
    enum MessageBatch {
        struct ViewModel {
            let cells: [DebateDetailSection]
        }
        struct Response {
            let messages: [Message]
            let hasNextPage: Bool
        }
    }
}

enum DebateDetailCellType {
    case message(Message)
    case reply(Message)
}
extension DebateDetailCellType: Equatable {

    static func == (lhs: DebateDetailCellType, rhs: DebateDetailCellType) -> Bool {
        switch (lhs, rhs) {
        case (.message(let lMessage), .message(let rMessage)):
            return lMessage == rMessage
        case (.reply(let lReply), .reply(let rReply)):
            return lReply.id == rReply.id
        default:
            return false
        }
    }

}

enum DebateDetailSectionType {
    case message(Message)
}
extension DebateDetailSectionType: Equatable {

    static func == (lhs: DebateDetailSectionType, rhs: DebateDetailSectionType) -> Bool {
        switch (lhs, rhs) {
        case (.message(let lMessage), .message(let rMessage)):
            return lMessage == rMessage
        }
    }

}

typealias DebateDetailSection = (section: DebateDetailSectionType, rows: [DebateDetailCellType])
