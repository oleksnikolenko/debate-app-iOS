//
//  DebatesResponse.swift
//  DiscussionMaker
//
//  Created by Artem Trubacheev on 05.04.2020.
//  Copyright © 2020 Artem Trubacheev. All rights reserved.
//

struct DebatesResponse: Decodable {

    var debates: [Discussion]
    var hasNextPage: Bool

}
