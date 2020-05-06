//
//  SearchRouter.swift
//  DiscussionMaker
//
//  Created by Alex Nikolenko on 04/05/2020.
//  Copyright © 2020 Artem Trubacheev. All rights reserved.
//

import Foundation

protocol SearchRoutingLogic {
    func navigateToDebate(_ debate: Discussion)
}

class SearchRouter: NSObject, SearchRoutingLogic {

    weak var viewController: SearchViewController?

    func navigateToDebate(_ debate: Discussion) {
        viewController?.navigationController?.pushViewController(
            DiscussionDetailViewController(debate: debate),
            animated: true
        )
    }

}
