//
//  CustdevView.swift
//  WhoCooler
//
//  Created by Artem Trubacheev on 02.09.2020.
//  Copyright © 2020 Artem Trubacheev. All rights reserved.
//

import UIKit
import RxSwift

class CustdevView: UIView {

    // MARK: - Views
    let headlineText = UILabel().with {
        $0.font = .boldSystemFont(ofSize: 20)
        $0.text = "custdev.title".localized
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
    let invitationText = UILabel().with {
        $0.font = .systemFont(ofSize: 14)
        $0.text = "custdev.description".localized
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
    let agreeButton = UIButton().with {
        $0.setTitle("custdev.agree".localized, for: .normal)
        $0.backgroundColor = .blue
        $0.titleLabel?.font = .boldSystemFont(ofSize: 15)
        $0.titleLabel?.textColor = .white
        $0.layer.cornerRadius = 10
    }

    // MARK: - Properties
    var didClickAgree: Observable<Void> { agreeButton.rx.tap.asObservable() }

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubviews(headlineText, invitationText, agreeButton)

        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = CGSize(width: 1, height: 1)
        layer.shadowOpacity = 1
        layer.shadowRadius = 10
        layer.masksToBounds = false
        layer.cornerRadius = 10
        backgroundColor = .white
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layout
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        pin.width(size.width)
        layout()

        return .init(
            width: size.width,
            height: agreeButton.frame.maxY + 16
        )
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        layout()
    }

    private func layout() {
        headlineText.pin
            .horizontally(20)
            .top(16)
            .sizeToFit(.width)

        invitationText.pin
            .below(of: headlineText)
            .marginTop(8)
            .horizontally(20)
            .sizeToFit(.width)

        agreeButton.pin
            .below(of: invitationText)
            .marginTop(16)
            .horizontally(16)
            .height(40)
    }

}

