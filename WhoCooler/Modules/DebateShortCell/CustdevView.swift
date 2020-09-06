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
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
    let agreeButton = UIButton().with {
        $0.backgroundColor = .blue
        $0.titleLabel?.font = .boldSystemFont(ofSize: 15)
        $0.titleLabel?.textColor = .white
        $0.layer.cornerRadius = 10
    }
    let textView = UITextView().with {
        $0.isUserInteractionEnabled = true
        $0.isEditable = true
        $0.isScrollEnabled = false
        $0.textContainerInset.left = 4
        $0.layer.cornerRadius = 4
        $0.layer.shadowColor = UIColor.lightGray.cgColor
        $0.layer.shadowOpacity = 1
        $0.layer.shadowRadius = 4
        $0.layer.shadowOffset = CGSize(width: 0, height: 1)
        $0.layer.masksToBounds = false
    }
    private let closeButton = UIButton().with {
        $0.tintColor = .gray
        $0.setImage(UIImage(named: "close"), for: .normal)
    }

    // MARK: - Properties
    var style: CustdevStyle = .contacts
    var didClickAgree: Observable<Void> { agreeButton.didClick.asObservable() }
    var didClickClose: Observable<Void> { closeButton.didClick.asObservable() }

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubviews(headlineText, invitationText, agreeButton, closeButton, textView)

        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize(width: 1, height: 1)
        layer.shadowOpacity = 1
        layer.shadowRadius = 4
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

       closeButton.pin
           .topEnd(12)
           .size(16)

        invitationText.pin
            .below(of: headlineText)
            .marginTop(8)
            .horizontally(20)
            .sizeToFit(.width)

        switch style {
        case .contacts:
            contactsLayout()
        case .text:
            textLayout()
        }
    }

    private func contactsLayout() {
        agreeButton.pin
            .below(of: invitationText)
            .marginTop(16)
            .horizontally(16)
            .height(40)
    }

    private func textLayout() {
        textView.pin
            .below(of: invitationText)
            .marginTop(8)
            .horizontally(20)
            .sizeToFit(.width)

        agreeButton.pin
            .below(of: textView)
            .marginTop(16)
            .horizontally(16)
            .height(40)
    }

    func setup(style: CustdevStyle) {
        self.style = style

        invitationText.text = style.descriptionText
        agreeButton.setTitle(style.agreeButtonText, for: .normal)
        textView.isHidden = style.isTextViewHidden

        setNeedsLayout()
    }

}
