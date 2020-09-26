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
        var cells: [DebateList.CellType] =
            [.categoryList(response.categories), .new] +
            response.data.map { .debate($0) }

        if cells.count == 2 && viewController?.selectedCategoryId == "favorites" {
            cells.append(.emptyFavorites)
            viewController?.noticeNoMoreData()
        }

        if
            cells.count >= 5 &&
            UserDefaultsService.shared.didSendCustdevContacts != true &&
            UserDefaultsService.shared.sessionCount > 1
        { cells.insert(.custdev(style: .contacts), at: 4) }

        /// Use this for debate of day logic
//        if let debateOfDay = response.data.first(where: { $0.debatePromotionType == .debateOfDay }) {
//            print(debateOfDay)
//        }

        if
            cells.count >= 10 &&
            UserDefaultsService.shared.didShowRateApp != true &&
            UserDefaultsService.shared.sessionCount > 2
        { cells.insert(.rateApp, at: 9) }

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
