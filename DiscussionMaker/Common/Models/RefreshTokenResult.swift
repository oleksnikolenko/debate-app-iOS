//
//  RefreshTokenResult.swift
//  DiscussionMaker
//
//  Created by Artem Trubacheev on 12.04.2020.
//  Copyright © 2020 Artem Trubacheev. All rights reserved.
//

struct RefreshTokenResult: Decodable {

    let accessToken: String

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
    }

}
