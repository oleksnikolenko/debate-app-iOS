//
//  AppleAuthenticationProvider.swift
//  WhoCooler
//
//  Created by Artem Trubacheev on 23.05.2020.
//  Copyright © 2020 Artem Trubacheev. All rights reserved.
//

import RxSwift
import Firebase
import AuthenticationServices
import CryptoKit

@available(iOS 13.0, *)
class AppleAuthenticationProvider: NSObject, AuthProvider {

    static let shared = AppleAuthenticationProvider()

    private override init() {
        super.init()
    }

    var type: AuthProviderType { .apple }
    var authResult: Observable<AuthToken> { authResultSubject.asObservable() }

    private let authResultSubject = PublishSubject<AuthToken>()
    private var currentNonce: String?

    func login() {
        performRequest()
    }

    private func performRequest() {
        let nonce = randomNonceString()
        currentNonce = nonce

        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)

        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.performRequests()
    }

    @available(iOS 13, *)
    private func sha256(_ input: String) -> String {
      let inputData = Data(input.utf8)
      let hashedData = SHA256.hash(data: inputData)
      let hashString = hashedData.compactMap {
        return String(format: "%02x", $0)
      }.joined()

      return hashString
    }

}

@available(iOS 13.0, *)
extension AppleAuthenticationProvider: ASAuthorizationControllerDelegate {

    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithAuthorization authorization: ASAuthorization
    ) {
        guard
            let appleCredential = authorization.credential as? ASAuthorizationAppleIDCredential,
            let tokenData = appleCredential.identityToken,
            let token = String(data: tokenData, encoding: .utf8),
            let nonce = currentNonce
        else { return }

        let credential = OAuthProvider.credential(
            withProviderID: "apple.com",
            idToken: token,
            rawNonce: nonce
        )

        Auth.auth().signIn(with: credential) { (authResult, error) in
            authResult?.user.getIDToken(completion: { [weak self] (idToken, _) in
                if let idToken = idToken {
                    self?.authResultSubject.onNext(.apple(token: idToken, name: appleCredential.fullName?.name))
                }
            })
        }

    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print(error)
    }

}

// Adapted from https://auth0.com/docs/api-auth/tutorials/nonce#generate-a-cryptographically-random-nonce
private func randomNonceString(length: Int = 32) -> String {
    precondition(length > 0)
    let charset: Array<Character> =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
    var result = ""
    var remainingLength = length

    while remainingLength > 0 {
        let randoms: [UInt8] = (0 ..< 16).map { _ in
            var random: UInt8 = 0
            let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
            if errorCode != errSecSuccess {
                fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
            }
            return random
        }

        randoms.forEach { random in
            if remainingLength == 0 {
                return
            }

            if random < charset.count {
                result.append(charset[Int(random)])
                remainingLength -= 1
            }
        }
    }

    return result
}

private extension PersonNameComponents {

    var name: String? {
        if let firstName = givenName,
            let lastName = familyName {
            return "\(firstName) \(lastName)"
        }
        return nil
    }

}
