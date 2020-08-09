//
//  CreateDebateInteractor.swift
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
import RxSwift

protocol CreateDebateBusinessLogic {
    func createDebateSides(request: CreateDebate.Creation.Sides.Request)
    func createDebateStatement(request: CreateDebate.Creation.Statement.Request)
}

protocol CreateDebateDataStore {}

class CreateDebateInteractor: CreateDebateBusinessLogic, CreateDebateDataStore {

    var presenter: CreateDebatePresentationLogic?
    var worker: CreateDebateWorker = CreateDebateWorker()

    let disposeBag = DisposeBag()

    // MARK: Do something
    func createDebateSides(request: CreateDebate.Creation.Sides.Request) {
        worker.createDebateSides(
            leftName: request.leftName,
            rightName: request.rightName,
            leftImage: request.leftImage,
            rightImage: request.rightImage,
            categoryId: request.categoryId,
            name: request.name
        ).subscribe(onNext: { [weak self] in
            AnalyticsService.shared.trackEvent(.newCreated(id: $0.id))
            self?.presenter?.didCreateDebate($0)
        }).disposed(by: disposeBag)
    }

    func createDebateStatement(request: CreateDebate.Creation.Statement.Request) {
        worker.createDebateStatement(
            leftName: request.leftName,
            rightName: request.rightName,
            debateImage: request.debateImage,
            categoryId: request.categoryId,
            name: request.name
        ).subscribe(onNext: { [weak self] in
            AnalyticsService.shared.trackEvent(.newCreated(id: $0.id))
            self?.presenter?.didCreateDebate($0)
        }).disposed(by: disposeBag)
    }

}
