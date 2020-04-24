//
//  UserProfileModels.swift
//  DiscussionMaker
//
//  Created by Artem Trubacheev on 24.04.2020.
//  Copyright (c) 2020 Artem Trubacheev. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

enum UserProfile {

    enum Profile {
        struct Request {}
        struct Response {
            var user: User
            var pushToken: String
            var accessToken: String
        }
        struct ViewModel {
            var user: User
            var pushToken: String
            var accessToken: String
        }
    }

}
