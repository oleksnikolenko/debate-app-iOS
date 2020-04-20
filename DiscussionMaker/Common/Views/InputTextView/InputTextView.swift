//
//  InputTextView.swift
//  DiscussionMaker
//
//  Created by Artem Trubacheev on 19.04.2020.
//  Copyright © 2020 Artem Trubacheev. All rights reserved.
//

import UIKit
import RxSwift

class InputTextView: UIView {

    // MARK: - Subviews
    private var textView = UITextView()
    private var avatar = UIImageView()
    private var sendButton = UIButton(type: .infoDark)

    // MARK: - Properties
    var text: String {
        textView.text
    }
    var textChange: Observable<String?> {
        textView.rx.text.asObservable()
    }
    var sendTap: Observable<String> {
        sendButton.rx.tap.map { [unowned self] in self.text }
    }

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubviews(
            textView,
            avatar,
            sendButton
        )
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()

        layout()
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        layout()

        return CGSize(
            width: size.width,
            height: textView.frame.maxY + 8
        )
    }

    func layout() {
        avatar.pin
            .size(24)
            .start(8)
            .top(8)

        sendButton.pin
            .size(24)
            .right(8)
            .top(8)

        textView.pin
            .before(of: sendButton)
            .after(of: avatar)
            .sizeToFit(.width)
            .top(8)
    }

    func emptyInput() {
        textView.text = ""
    }

    override func resignFirstResponder() -> Bool {
        return textView.resignFirstResponder() && super.resignFirstResponder()
    }

}
