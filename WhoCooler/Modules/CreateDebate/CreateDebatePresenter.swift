//
//  CreateDebatePresenter.swift
//  WhoCooler
//
//  Created by Artem Trubacheev on 31.05.2020.
//  Copyright (c) 2020 Artem Trubacheev. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol CreateDebatePresentationLogic {
    func didCreateDebate(_ debate: Debate)
}

class CreateDebatePresenter: CreateDebatePresentationLogic {
    weak var viewController: CreateDebateDisplayLogic?

    // MARK: Do something
    func didCreateDebate(_ debate: Debate) {
        viewController?.didCreateDebate(debate)
    }
}
