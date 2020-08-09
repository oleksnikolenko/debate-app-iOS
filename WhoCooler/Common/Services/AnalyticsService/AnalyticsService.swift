//
//  AnalyticsService.swift
//  WhoCooler
//
//  Created by Artem Trubacheev on 09.08.2020.
//  Copyright © 2020 Artem Trubacheev. All rights reserved.
//

import Firebase

class AnalyticsService {

    static let shared = AnalyticsService()
    private init() {}

    func trackEvent(_ event: AnalyticsEvent) {
        Analytics.logEvent(event.name, parameters: event.parameters)
    }

    func trackScreen(_ screen: AnalyticsScreen) {
        Analytics.logEvent("screenview", parameters: ["name": screen.rawValue])
        Analytics.setScreenName(screen.rawValue, screenClass: nil)
    }

}

public enum AnalyticsEvent {
    case didClickNew
    case loginTry(provider: String)
    case loginSuccess
    case newCreated(id: String)
    case commentSendTry
    case commentSentSuccess
}

public enum AnalyticsScreen: String {
    case list
    case create
    case detail
    case auth
}

extension AnalyticsEvent {

    var name: String {
        switch self {
        case .didClickNew: return "new_button_clicked"
        case .loginTry: return "login_try"
        case .loginSuccess: return "login_success"
        case .newCreated: return "new_created"
        case .commentSendTry: return "comment_send_try"
        case .commentSentSuccess: return "comment_sent_success"
        }
    }

    var parameters: [String: Any]? {
        switch self {
        case .didClickNew, .commentSentSuccess, .commentSendTry, .loginSuccess:
            return nil
        case .loginTry(let provider):
            return ["provider": provider]
        case .newCreated(let id):
            return ["id": id]
        }
    }

}
