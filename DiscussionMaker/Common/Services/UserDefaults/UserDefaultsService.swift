//
//  UserDefaultsService.swift
//  DiscussionMaker
//
//  Created by Artem Trubacheev on 12.04.2020.
//  Copyright © 2020 Artem Trubacheev. All rights reserved.
//

import UIKit

class UserDefaultsService {

    static let shared = UserDefaultsService()

    private init() {}
    private let userDefaults = UserDefaults()

    var session: Session? {
        get {
            guard let data = userDefaults.data(forKey: #function) else { return nil }
            return try? JSONDecoder().decode(Session.self, from: data)
        } set {
            guard let session = newValue else {
                userDefaults.set(nil, forKey: #function)
                return
            }
            guard let data = try? JSONEncoder().encode(newValue) else { return }
            userDefaults.set(data, forKey: "session")
        }
    }

}
