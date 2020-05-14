//
//  AuthorizationScreenInteractor.swift
//  WhoCooler
//
//  Created by Artem Trubacheev on 04.04.2020.
//  Copyright (c) 2020 Artem Trubacheev. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import RxSwift

protocol AuthorizationScreenBusinessLogic {
    func getProviders(request: AuthorizationScreen.Providers.Request)
    func didSelectProvider(request: AuthorizationScreen.Authorization.Request)
}

protocol AuthorizationScreenDataStore {}

class AuthorizationScreenInteractor: AuthorizationScreenBusinessLogic, AuthorizationScreenDataStore {

    var presenter: AuthorizationScreenPresentationLogic?
    var worker = AuthorizationScreenWorker()
    let disposeBag = DisposeBag()

    // MARK: Do something
    func getProviders(request: AuthorizationScreen.Providers.Request) {
        presenter?.presentProviders(
            response: .init(
                providers: [
                    GoogleAuthenticationProvider.shared,
                    FacebookAuthenticationProvider.shared
                ]
            )
        )
    }

    func didSelectProvider(request: AuthorizationScreen.Authorization.Request) {
        request.provider.authResult
            .flatMap { [weak self] in self?.worker.authorize(with: $0) ?? .never() }
            .subscribe(onNext: { [weak self] _ in
                self?.presenter?.didFinishAuth(response: .init())
            })
            .disposed(by: disposeBag)

        request.provider.login()
    }

}
