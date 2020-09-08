//
//  UserDefaultsService.swift
//  WhoCooler
//
//  Created by Artem Trubacheev on 12.04.2020.
//  Copyright © 2020 Artem Trubacheev. All rights reserved.
//

import UIKit
import RxSwift

class UserDefaultsService {

    static let shared = UserDefaultsService()

    private init() {}
    private let userDefaults = UserDefaults()

    var session: UserSession? {
        get {
            guard let data = userDefaults.data(forKey: #function) else { return nil }
            return try? JSONDecoder().decode(UserSession.self, from: data)
        } set {
            defer {
                didUpdateUserSubject.onNext(())
            }
            guard let session = newValue else {
                userDefaults.set(nil, forKey: #function)
                return
            }
            guard let data = try? JSONEncoder().encode(session) else { return }
            userDefaults.set(data, forKey: "session")
        }
    }

    var fcmToken: String? {
        get { userDefaults.string(forKey: #function) }
        set { userDefaults.set(newValue, forKey: #function) }
    }

    var didSendCustdevContacts: Bool? {
        get { userDefaults.bool(forKey: #function) }
        set { userDefaults.set(newValue, forKey: #function) }
    }

    var didSendCustdevFeedback: Bool? {
        get { userDefaults.bool(forKey: #function) }
        set { userDefaults.set(newValue, forKey: #function) }
    }

    var rateAppState: String? {
        get { userDefaults.string(forKey: #function) }
        set { userDefaults.set(newValue, forKey: #function) }
    }

    var sessionCount: Int {
        get { userDefaults.integer(forKey: #function) }
        set { userDefaults.set(newValue, forKey: #function) }
    }

    var didShowRateApp: Bool? {
        get { userDefaults.bool(forKey: #function) }
        set { userDefaults.set(newValue, forKey: #function) }
    }

    var didUpdateUser: Observable<Void> {
        didUpdateUserSubject.asObservable()
    }
    private var didUpdateUserSubject = PublishSubject<Void>()

}
