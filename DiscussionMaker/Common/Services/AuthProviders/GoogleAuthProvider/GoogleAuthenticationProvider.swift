//
//  GoogleAuthenticationProvider.swift
//  DiscussionMaker
//
//  Created by Artem Trubacheev on 12.04.2020.
//  Copyright © 2020 Artem Trubacheev. All rights reserved.
//

import RxSwift
import Firebase
import GoogleSignIn

class GoogleAuthenticationProvider: NSObject, AuthProvider {

    static let shared = GoogleAuthenticationProvider()

    private override init() {
        super.init()

    }

    var type: AuthProviderType { .google }
    var authResult: Observable<String> { authResultSubject.asObservable() }

    private var authResultSubject = PublishSubject<String>()

    func login() {
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = UIApplication.shared.keyWindow?.rootViewController
        GIDSignIn.sharedInstance()?.signIn()
    }

    func logout() {
        GIDSignIn.sharedInstance()?.signOut()
    }

}

extension GoogleAuthenticationProvider: GIDSignInDelegate {

    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        print(user)
    }

    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        guard
            user != nil,
            let authentication = user.authentication
        else { return }

        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                          accessToken: authentication.accessToken)

        Auth.auth().signIn(with: credential) { [weak self] (authResult, _) in
            authResult?.user.getIDToken(completion: { [weak self] (idToken, _) in
                if let idToken = idToken {
                    self?.authResultSubject.onNext(idToken)
                }
            })
        }
    }

}


