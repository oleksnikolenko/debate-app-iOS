//
//  AuthButton.swift
//  WhoCooler
//
//  Created by Artem Trubacheev on 12.04.2020.
//  Copyright © 2020 Artem Trubacheev. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import AuthenticationServices

protocol AuthButtonProtocol: UIView {
    var authProviderSelected: Observable<AuthProvider> { get }
    var provider: AuthProvider { get }
}

@available(iOS 13, *)
class AppleAuthButton: ASAuthorizationAppleIDButton, AuthButtonProtocol {

    // MARK: - Properties
    let provider: AuthProvider
    var authProviderSelected: Observable<AuthProvider> {
        rx.controlEvent(.touchUpInside).map { [unowned self] in self.provider }
    }


    init(provider: AuthProvider) {
        self.provider = provider
        super.init(authorizationButtonType: .signIn, authorizationButtonStyle: .white)

        clipsToBounds = true
        commonSetup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func commonSetup() {
        contentMode = .center
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOpacity = 1
        layer.shadowRadius = 8
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.masksToBounds = false
    }

}

class AuthButton: UIButton, AuthButtonProtocol {

    // MARK: - Subviews
    private let providerNameLabel = UILabel().with {
        $0.font = UIFont.systemFont(ofSize: 16, weight: .regular)
    }
    private let providerImageView = UIImageView()

    // MARK: - Properties
    private let disposeBag = DisposeBag()
    let provider: AuthProvider
    var authProviderSelected: Observable<AuthProvider> {
        return rx.tap.map { [unowned self] in self.provider }
    }

    // MARK: - Init
    init(provider: AuthProvider) {
        self.provider = provider
        super.init(frame: .zero)

        addSubviews()
        commonSetup()
        providerSetup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()

        layout()
    }

    private func layout() {
        let imageSize = CGSize(width: 30, height: 30)

        providerImageView.pin
            .size(imageSize)
            .start(10)
            .vCenter()

        providerNameLabel.pin
            .sizeToFit()
            .center()
    }

    // MARK: - Private Methods
    private func addSubviews() {
        addSubviews([providerNameLabel, providerImageView])
    }

    private func providerSetup() {
        backgroundColor = provider.type.backgroundColor
        providerNameLabel.text = provider.type.title
        providerNameLabel.textColor = provider.type.textColor
        providerImageView.image = provider.type.image
    }

    private func commonSetup() {
        contentMode = .center
        layer.cornerRadius = 8
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOpacity = 1
        layer.shadowRadius = 8
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.masksToBounds = false
    }

}

private extension AuthProviderType {

    var image: UIImage? {
        switch self {
        case .google:
            return UIImage(named: "google")
        case .facebook:
            return UIImage(named: "facebook")
        case .apple:
            return nil
        }
    }

    var title: String? {
        switch self {
        case .google:
            return "Google"
        case .facebook:
            return "Facebook"
        case .apple:
            return "Apple"
        }
    }

    var backgroundColor: UIColor {
        switch self {
        case .google:
            return .white
        case .facebook:
            return .white
        case .apple:
            return .white
        }
    }

    var textColor: UIColor {
        switch self {
        case .google:
            return .gray
        case .facebook:
            return .gray
        case .apple:
            return .gray
        }
    }

}
