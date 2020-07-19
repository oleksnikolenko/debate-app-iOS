//
//  AuthContainerView.swift
//  WhoCooler
//
//  Created by Alex Nikolenko on 18.07.2020.
//  Copyright © 2020 Artem Trubacheev. All rights reserved.
//

import UIKit

class AuthContainerView: UIView {

    // MARK: - Subviews
    var appLogo = UIImageView().with {
        $0.image = UIImage(named: "AppLogo")
        // TODO - remove this when new flipped icon is ready
        $0.transform = CGAffineTransform(scaleX: 1, y: -1)
    }
    var authProviderButtons: [AuthButtonProtocol] = [] {
        didSet {
            oldValue.forEach { $0.removeFromSuperview() }
            addSubviews(authProviderButtons)
            setNeedsLayout()
        }
    }
    var informationLabel = UILabel().with {
        $0.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        $0.textColor = UIColor.black
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.text = "auth.infoText".localized
    }
    private let privacyTermsView = UITextView().with {
        $0.font = UIFont.systemFont(ofSize: 8)
        $0.textColor = UIColor.gray
        $0.textAlignment = .center
        $0.isEditable = false
        $0.isUserInteractionEnabled = true
        $0.linkTextAttributes = [
            .foregroundColor: UIColor.systemBlue,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
    }

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubviews(informationLabel, appLogo, privacyTermsView)
        setupPrivacyTermsView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()

        layout()
    }

    func layout() {
        appLogo.pin
            .top()
            .size(120)
            .hCenter()

        informationLabel.pin
            .horizontally(48)
            .below(of: appLogo)
            .sizeToFit(.width)
            .marginTop(40)

        var lastEdge = informationLabel.edge.bottom

        authProviderButtons.forEach {
            if $0.provider.type == .google {
                $0.pin
                    .height(44)
                    .horizontally(48)
                    .marginTop(40)
                    .below(of: informationLabel)
            } else {
                $0.pin
                    .height(44)
                    .horizontally(48)
                    .top(to: lastEdge)
                    .marginTop(12)
            }

            lastEdge = $0.edge.bottom
        }

        privacyTermsView.pin
            .top(to: lastEdge)
            .horizontally(48)
            .marginTop(16)
            .sizeToFit(.width)
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        pin.width(size.width)
        layout()
        return CGSize(width: size.width, height: privacyTermsView.frame.maxY)
    }

    private func setupPrivacyTermsView() {
        let mainAttrString = NSMutableAttributedString(string: "auth.byProceeding".localized)

        guard
            let termsOfUseUrl = URL(string: "https://api.whocooler.com/terms"),
            let privacyPolicyUrl = URL(string: "https://www.iubenda.com/privacy-policy/66454455")
        else { return }

        let termsOfUseText = NSAttributedString(string: "auth.termsOfUse.info".localized)
        let privacyPolicyText = NSAttributedString(string: "auth.privacy".localized)

        let termsOfUseMutableString = NSMutableAttributedString(attributedString: termsOfUseText).with {
            $0.setAttributes([.link: termsOfUseUrl], range: NSRange(location: 0, length: termsOfUseText.length))
        }

        let privacyMutableString = NSMutableAttributedString(attributedString: privacyPolicyText).with {
            $0.setAttributes([.link: privacyPolicyUrl], range: NSRange(location: 0, length: privacyPolicyText.length))
        }

        let secondSentence = NSMutableAttributedString(string: "auth.toFindOut".localized)

        mainAttrString.append(termsOfUseMutableString)
        mainAttrString.append(secondSentence)
        mainAttrString.append(privacyMutableString)

        privacyTermsView.attributedText = mainAttrString
        privacyTermsView.textAlignment = .center
        privacyTermsView.textColor = .gray
    }

}
