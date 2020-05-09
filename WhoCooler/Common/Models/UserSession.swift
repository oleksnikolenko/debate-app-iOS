//
//  UserSession.swift
//  WhoCooler
//
//  Created by Artem Trubacheev on 12.04.2020.
//  Copyright © 2020 Artem Trubacheev. All rights reserved.
//

struct UserSession: Codable {

    var user: User
    var accessToken: String
    var refreshToken: String

    enum CodingKeys: String, CodingKey {
        case user
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
    }

}
