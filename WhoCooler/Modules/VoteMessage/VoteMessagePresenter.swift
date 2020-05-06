//
//  VoteMessagePresenter.swift
//  WhoCooler
//
//  Created by Alex Nikolenko on 30/04/2020.
//  Copyright © 2020 Artem Trubacheev. All rights reserved.
//

import UIKit

protocol VoteMessagePresentationLogic {
    func didVote(model: Votable)
}

class VoteMessagePresenter: VoteMessagePresentationLogic {

    weak var view: VoteMessageDisplayLogic?

    func didVote(model: Votable) {
        view?.update(model: model)
    }
    
}
