//
//  DiscussionInfoView.swift
//  DiscussionMaker
//
//  Created by Alex Nikolenko on 26/04/2020.
//  Copyright © 2020 Artem Trubacheev. All rights reserved.
//

import UIKit

class DiscussionInfoView: UIView {

    // MARK: - Views
    let userImage = UIImageView().with {
        $0.image = UIImage(named: "user")
    }
    let userCount = UILabel().with {
        $0.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
    }
    let messageImage = UIImageView().with {
        $0.image = UIImage(named: "message")
    }
    let messageCount = UILabel().with {
        $0.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
    }

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubviews([
            userImage,
            userCount,
            messageImage,
            messageCount
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()

        layout()
    }

    private func layout() {
        userImage.pin
            .size(18)
            .topStart()

        userCount.pin
            .after(of: userImage)
            .vCenter(to: userImage.edge.vCenter)
            .marginStart(10)
            .sizeToFit()

        messageImage.pin
            .size(18)
            .after(of: userCount)
            .marginStart(12)
            .top()

        messageCount.pin
            .after(of: messageImage)
            .vCenter(to: messageImage.edge.vCenter)
            .marginStart(10)
            .sizeToFit()
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        layout()

        return .init(
            width: messageCount.frame.maxX,
            height: messageImage.frame.maxY
        )
    }

    // MARK: - Public methods
    func setup(_ discussion: Discussion) {
        userCount.text = discussion.votesCount.description
        messageCount.text = discussion.messagesList.messages.count.description

        setNeedsLayout()
    }

}
