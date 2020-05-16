//
//  VoteMessageInteractor.swift
//  WhoCooler
//
//  Created by Alex Nikolenko on 30/04/2020.
//  Copyright © 2020 Artem Trubacheev. All rights reserved.
//

import RxSwift

protocol VoteMessageBusinessLogic {
    func vote(model: Votable, voteType: VoteType, style: MessageStyle)
    func unvote(_ model: Votable, style: MessageStyle)
}

protocol Votable {
    var voteType: VoteType { get }
    var objectId: String { get }
    var threadId: String? { get }
    var votesCount: Int { get }

    func setVoteType(_ voteType: VoteType)
    func didVote(voteModel: VoteModel, voteType: VoteType)
}

class VoteMessageInteractor: VoteMessageBusinessLogic {

    var presenter: VoteMessagePresentationLogic?
    var worker = VoteMessageWorker()
    let userDefaults = UserDefaultsService.shared

    private let disposeBag = DisposeBag()

    func vote(model: Votable, voteType: VoteType, style: MessageStyle) {
        guard userDefaults.session != nil else { presenter?.authRequired(); return }
        model.setVoteType(voteType)

        worker
            .postVote(objectId: model.objectId, voteType: voteType, style: style)
            .subscribe(onNext: { [weak self] modifiedModel in
                guard let `self` = self else { return }

                model.didVote(voteModel: modifiedModel, voteType: voteType)
                self.presenter?.didVote(model: model)
            }, onError: { [weak self] in
                self?.handleError($0)
            }).disposed(by: disposeBag)
    }

    func unvote(_ model: Votable, style: MessageStyle) {
        guard userDefaults.session != nil else { presenter?.authRequired(); return }
        model.setVoteType(.none)

        worker
            .deleteVote(objectId: model.objectId, style: style)
            .subscribe(onNext: { [weak self] modifiedModel in
                guard let `self` = self else { return }

                model.didVote(voteModel: modifiedModel, voteType: .none)
                self.presenter?.didVote(model: model)
            }, onError: { [weak self] in
                self?.handleError($0)
            }).disposed(by: disposeBag)
    }

    private func handleError(_ error: Error) {
        switch error.type {
        case .noInternet:
            presenter?.presentNoInternet()
        case .unauthorized:
            presenter?.authRequired()
        case .unknown:
            /// TODO - Handle error
            break
        }
    }

}
