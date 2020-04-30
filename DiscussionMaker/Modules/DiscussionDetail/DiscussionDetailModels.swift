//
//  DiscussionDetailModels.swift
//  DiscussionMaker
//
//  Created by Artem Trubacheev on 09.04.2020.
//  Copyright (c) 2020 Artem Trubacheev. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

enum DiscussionDetail {
    // MARK: Use cases
    enum Initializing {
        struct Request {
            let debate: Discussion
        }
        struct Response {
            let debate: Discussion
        }
        struct ViewModel {
            let debate: Discussion
            let sections: [DiscussionDetailSection]
        }
    }

    enum Vote {
        struct Request {
            let sideId: String
        }
    }

    enum ChatSend {
        struct Request {
            let message: String
        }
    }

}

enum DiscussionDetailCellType {
    case message(Message)
}
extension DiscussionDetailCellType: Equatable {
    static func == (lhs: DiscussionDetailCellType, rhs: DiscussionDetailCellType) -> Bool {
        switch (lhs, rhs) {
        case (.message(let lMessage), .message(let rMessage)):
            return lMessage == rMessage
        }
    }
}

enum DiscussionDetailSectionType {
    case message(Message)
}
extension DiscussionDetailSectionType: Equatable {
    static func == (lhs: DiscussionDetailSectionType, rhs: DiscussionDetailSectionType) -> Bool {
        switch (lhs, rhs) {
        case (.message(let lMessage), .message(let rMessage)):
            return lMessage == rMessage
        }
    }
}

typealias DiscussionDetailSection = (section: DiscussionDetailSectionType, rows: [DiscussionDetailCellType])
