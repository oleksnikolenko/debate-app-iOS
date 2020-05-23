//
//  AuthProvider.swift
//  WhoCooler
//
//  Created by Artem Trubacheev on 12.04.2020.
//  Copyright © 2020 Artem Trubacheev. All rights reserved.
//

import RxSwift

protocol AuthProvider {

    var authResult: Observable<AuthToken> { get }
    var type: AuthProviderType { get }
    func login()
    func logout()

}

extension AuthProvider {

    func logout () {}

}

enum AuthProviderType: String {
    case google
    case facebook
    case apple
}

enum AuthToken {
    case google(token: String)
    case facebook(token: String)
    case apple(token: String, name: String?)
}
