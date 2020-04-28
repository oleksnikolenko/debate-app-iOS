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
    var textView = UITextView().with {
        $0.text = "Tell others what you think"
        $0.textColor = UIColor.gray
        $0.backgroundColor = UIColor(hex: 0xF1F1F1)
        $0.textContainerInset = UIEdgeInsets(top: 8, left: 12, bottom: 0, right: 12)
        $0.font = UIFont.systemFont(ofSize: 14, weight: .regular)
    }
    private var avatar = UIImageView().with {
        $0.image = UIImage(named: "google")
    }
    private var sendButton = UIButton().with {
        // TODO: - Localize
        $0.setTitle("Send", for: .normal)
        $0.setTitleColor(UIColor.systemBlue, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
    }
    private let separatorView = UIView().with {
        $0.backgroundColor = .lightGray
        $0.alpha = 0.5
    }

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
    private var textViewHeight: CGFloat {
        textView.sizeThatFits(
            CGSize(width: textView.bounds.width, height: .infinity)
        ).height.inRange(of: textFieldHeightBounds)
    }
    private let textFieldHeightBounds: ClosedRange<CGFloat> = 32...128
    private var totalHeight: CGFloat {
        return textViewHeight + verticalMargin * 2
    }
    private let verticalMargin: CGFloat = 12

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubviews(
            textView,
            avatar,
            sendButton,
            separatorView
        )
        setup()
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
            height: totalHeight //+ max(verticalMargin, safeAreaInsets.bottom)
        )
    }

    func layout() {
        separatorView.pin
            .top()
            .horizontally()
            .height(0.5)
//        avatar.pin
//            .size(32)
//            .start(20)
//            .bottom(verticalMargin)

        sendButton.pin
            .sizeToFit()
            .end(20)
            .bottom(verticalMargin)

        textView.pin
            .before(of: sendButton)
            .start(10)
            .height(textViewHeight)
            .marginHorizontal(10)
            .bottom(verticalMargin)
//            .vCenter(to: avatar.edge.vCenter)
    }

    private func setup() {
        textView.layer.cornerRadius = 14
        backgroundColor = .white
    }

    func emptyInput() {
        textView.text = ""
    }

    override func resignFirstResponder() -> Bool {
        return textView.resignFirstResponder() && super.resignFirstResponder()
    }

}

extension Comparable {

    public func inRange(of range: ClosedRange<Self>) -> Self {
        return min(max(range.lowerBound, self), range.upperBound)
    }

}
