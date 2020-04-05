//
//  Discussion.swift
//  DiscussionMaker
//
//  Created by Artem Trubacheev on 26.01.2020.
//  Copyright © 2020 Artem Trubacheev. All rights reserved.
//

struct Discussion: Decodable {
    let id: String
    let name: String
    let leftSide: DiscussionSide
    let rightSide: DiscussionSide

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case leftSide = "leftside"
        case rightSide = "rightside"
    }
}
