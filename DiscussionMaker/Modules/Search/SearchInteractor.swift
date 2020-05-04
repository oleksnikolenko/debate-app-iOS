//
//  SearchInteractor.swift
//  DiscussionMaker
//
//  Created by Alex Nikolenko on 04/05/2020.
//  Copyright © 2020 Artem Trubacheev. All rights reserved.
//

import RxSwift

protocol SearchBusinessLogic {
    func search(request: SearchModel.Request)
    func getNextPage()
}

class SearchInteractor: SearchBusinessLogic {

    var presenter: SearchPresentationLogic?
    let worker = SearchWorker()

    private var page = 1
    private var searchContext = ""
    private let disposeBag = DisposeBag()
    private var response = SearchResponse(debates: [], hasNextPage: false)

    func search(request: SearchModel.Request) {
        worker.search(context: request.searchContext, page: request.page)
            .subscribe(onNext: { [weak self] in
                guard let `self` = self else { return }

                self.presenter?.presentDebates(
                    response: .init(debates: $0.debates, hasNextPage: $0.hasNextPage)
                )
                self.searchContext = request.searchContext
                self.page = 1
                self.response = $0
            }).disposed(by: disposeBag)
    }

    func getNextPage() {
        worker.search(context: searchContext, page: page + 1)
            .subscribe(onNext: { [weak self] in
                guard let `self` = self else { return }

                self.response.debates += $0.debates
                self.response.hasNextPage = $0.hasNextPage

                self.presenter?.presentDebates(
                    response: .init(
                        debates: self.response.debates,
                        hasNextPage: self.response.hasNextPage
                    )
                )

                self.page += 1
            }).disposed(by: disposeBag)
    }

}
