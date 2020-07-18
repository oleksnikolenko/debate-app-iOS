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
    private lazy var lastView: UIView = informationLabel

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubviews(informationLabel, appLogo)
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
            lastView = $0
        }
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        pin.width(size.width)
        layout()
        return CGSize(width: size.width, height: lastView.frame.maxY)
    }

}
