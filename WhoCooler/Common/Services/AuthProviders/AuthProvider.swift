//
//  AuthProvider.swift
//  WhoCooler
//
//  Created by Artem Trubacheev on 12.04.2020.
//  Copyright © 2020 Artem Trubacheev. All rights reserved.
//

import RxSwift

protocol AuthProvider {

    var authResult: Observable<String> { get }
    var type: AuthProviderType { get }
    func login()
    func logout()

}

enum AuthProviderType: String {
    case google
}
