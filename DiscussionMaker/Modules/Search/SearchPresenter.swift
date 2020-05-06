//
//  SearchPresenter.swift
//  DiscussionMaker
//
//  Created by Alex Nikolenko on 04/05/2020.
//  Copyright © 2020 Artem Trubacheev. All rights reserved.
//

protocol SearchPresentationLogic {
    func presentDebates(response: SearchModel.Response)
}

class SearchPresenter: SearchPresentationLogic {

    weak var view: SearchDisplayLogic?

    func presentDebates(response: SearchModel.Response) {
        let cells: [SearchModel.CellType] = response.debates.map { .debate($0) }

        view?.displayCells(viewModel: .init(cells: cells, hasNextPage: response.hasNextPage))
    }

}
