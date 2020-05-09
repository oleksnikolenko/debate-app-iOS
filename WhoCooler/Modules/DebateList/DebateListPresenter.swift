//
//  DebateListPresenter.swift
//  WhoCooler
//
//  Created by Artem Trubacheev on 18.01.2020.
//  Copyright (c) 2020 Artem Trubacheev. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol DebateListPresentationLogic {
    func presentSomething(response: DebateList.Something.Response)
    func reloadDebate(debate: Debate)
    func presentAuthScreen()
    func presentNoInternet()
}

class DebateListPresenter: DebateListPresentationLogic {
    weak var viewController: DebateListDisplayLogic?

    // MARK: Do something
    func presentSomething(response: DebateList.Something.Response) {
        let cells: [DebateList.CellType] =
            [.categoryList(response.categories)] +
            response.data.map { .debate($0) }

        viewController?.displayCells(viewModel:
            .init(cells: cells, hasNextPage: response.hasNextPage)
        )
    }

    func reloadDebate(debate: Debate) {
        viewController?.reloadDebate(debateCell: .debate(debate))
    }

    func presentAuthScreen() {
        viewController?.navigateToAuthorization()
    }

    func presentNoInternet() {
        viewController?.showNoInternet()
    }

}
