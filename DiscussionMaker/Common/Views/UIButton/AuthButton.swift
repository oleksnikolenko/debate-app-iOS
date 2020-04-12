//
//  AuthButton.swift
//  DiscussionMaker
//
//  Created by Artem Trubacheev on 12.04.2020.
//  Copyright © 2020 Artem Trubacheev. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class AuthButton: UIButton {

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

        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private Methods
    private func setup() {
        let cornerRadius: CGFloat = 14
        setTitle(provider.type.title, for: .normal)
        backgroundColor = provider.type.backgroundColor
        setTitleColor(provider.type.textColor, for: .normal)
        titleLabel?.font = .boldSystemFont(ofSize: 14)
        contentMode = .center
        layer.cornerRadius = cornerRadius
    }

}

private extension AuthProviderType {

    var title: String? {
        switch self {
        case .google:
            return "Google"
        }
    }

    var backgroundColor: UIColor {
        switch self {
        case .google:
            return .red
        }
    }

    var textColor: UIColor {
        switch self {
        case .google:
            return .white
        }
    }

}
