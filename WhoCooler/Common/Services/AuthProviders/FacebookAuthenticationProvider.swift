//
//  FacebookAuthenticationProvider.swift
//  WhoCooler
//
//  Created by Alex Nikolenko on 13/05/2020.
//  Copyright © 2020 Artem Trubacheev. All rights reserved.
//

import FBSDKLoginKit
import Firebase
import RxSwift

class FacebookAuthenticationProvider: NSObject, AuthProvider {

    static let shared = FacebookAuthenticationProvider()

    private var authResulSubject = PublishSubject<AuthToken>()

    var authResult: Observable<AuthToken> { authResulSubject.asObservable() }

    var type: AuthProviderType { .facebook }

    func login() {
        let loginManager = LoginManager()
        loginManager.logIn(
            permissions: ["public_profile", "email"],
            from: UIApplication.shared.keyWindow?.rootViewController,
            handler: { [weak self] result, _ -> Void in
                guard let result = result, !result.isCancelled, let token = result.token?.tokenString else { return }

                let credential = FacebookAuthProvider.credential(withAccessToken: token)
                Auth.auth().signIn(with: credential) { [weak self] (authResult, _) in
                    authResult?.user.getIDToken(completion: { [weak self] (idToken, _) in
                        if let idToken = idToken {
                            self?.authResulSubject.onNext(.facebook(token: idToken))
                        }
                    })
                }
            }
        )
    }

    func logout() {
        LoginManager().logOut()
    }

}
