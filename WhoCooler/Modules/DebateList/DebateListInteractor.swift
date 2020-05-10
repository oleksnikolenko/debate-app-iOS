//
//  DebateListInteractor.swift
//  DebateMaker
//
//  Created by Artem Trubacheev on 18.01.2020.
//  Copyright (c) 2020 Artem Trubacheev. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import Foundation
import RxSwift

protocol DebateListBusinessLogic {
    func getData(request: DebateList.Something.Request)
    func getNextPage()
    func toggleFavorites(
        request: DebateList.Favorites.PostRequest,
        successCompletion: (() -> Void)?
    )
    func reloadDebate(debateId: String)
    func vote(debateId: String, sideId: String, successCompletion: ((Debate) -> Void)?)
}

protocol DebateListDataStore {}

class DebateListInteractor: DebateListBusinessLogic, DebateListDataStore {

    var presenter: DebateListPresentationLogic?
    var worker = DebateListWorker()

    let disposeBag = DisposeBag()

    private var response = DebatesResponse()
    private var page = 1
    private var categoryId: String?
    private var selectedSorting: String = "popular"

    // MARK: - Do something
    func getData(request: DebateList.Something.Request) {
        worker.getDebates(
            categoryId: request.categoryId,
            sorting: request.selectedSorting
        ).subscribe(onNext: { [weak self] in
            self?.presenter?.presentSomething(response:
                .init(
                    data: $0.debates,
                    categories: $0.categories,
                    hasNextPage: $0.hasNextPage
                )
            )
            self?.response = $0
            self?.categoryId = request.categoryId
            self?.selectedSorting = request.selectedSorting
            self?.page = 1
        }, onError: { [weak self] in
            self?.handleError($0)
        }).disposed(by: disposeBag)
    }

    func reloadDebate(debateId: String) {
        worker.getDebate(id: debateId).subscribe(onNext: { [weak self] in
            self?.presenter?.reloadDebate(debate: $0)
        }).disposed(by: disposeBag)
    }

    func vote(debateId: String, sideId: String, successCompletion: ((Debate) -> Void)?) {
        worker.vote(debateId: debateId, sideId: sideId)
            .subscribe(onNext: {
                successCompletion?($0.debate)
            }, onError: { [weak self] in
                self?.handleError($0)
            }).disposed(by: disposeBag)
    }

    func getNextPage() {
        worker.getDebates(
            page: page + 1,
            categoryId: categoryId,
            sorting: selectedSorting
        ).subscribe(onNext: { [weak self] in
            guard let `self` = self else { return }

            self.response.debates += $0.debates
            self.response.hasNextPage = $0.hasNextPage

            self.presenter?.presentSomething(response:
                .init(
                    data: self.response.debates,
                    categories: self.response.categories,
                    hasNextPage: self.response.hasNextPage
                )
            )
            self.page += 1
        }).disposed(by: disposeBag)
    }

    func toggleFavorites(request: DebateList.Favorites.PostRequest, successCompletion: (() -> Void)?) {
        worker.toggleFavorites(request: request)
            .subscribe(onNext: { _ in
                successCompletion?()
            }, onError: { [weak self] in
                self?.handleError($0)
            }).disposed(by: disposeBag)
    }

    private func handleError(_ error: Error) {
        switch error.type {
        case .noInternet:
            presenter?.presentNoInternet()
        case .unauthorized:
            presenter?.presentAuthScreen()
        case .unknown:
            /// TODO - Handle error
            break
        }
    }
    
}
