//
//  DiscussionSide.swift
//  DiscussionMaker
//
//  Created by Artem Trubacheev on 05.04.2020.
//  Copyright © 2020 Artem Trubacheev. All rights reserved.
//

struct DiscussionSide: Decodable {
    let id: String
    let name: String
    let image: String
    let ratingCount: Int
}
