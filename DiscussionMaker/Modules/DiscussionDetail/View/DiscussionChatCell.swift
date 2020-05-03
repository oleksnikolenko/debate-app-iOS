//
//  DiscussionChatCell.swift
//  DiscussionMaker
//
//  Created by Artem Trubacheev on 11.04.2020.
//  Copyright © 2020 Artem Trubacheev. All rights reserved.
//

import SUHelpers
import UIKit

class DiscussionChatCell: UITableViewCell {

    // MARK: - Subviews
    lazy var avatar = UIImageView().with {
        $0.layer.cornerRadius = avatarSize.height / 2
        $0.layer.masksToBounds = true
        $0.clipsToBounds = true
    }
    let name = UILabel().with {
        $0.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
    }
    let messageLabel = UILabel().with {
        $0.numberOfLines = 0
        $0.font = UIFont.systemFont(ofSize: 14, weight: .regular)
    }
    let dateLabel = UILabel().with {
        $0.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        $0.textColor = .lightGray
    }
    let voteButton = VoteMessageButton()

    // MARK: - Properties
    var model: Message?
    let avatarSize = CGSize(width: 36, height: 36)

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        clipsToBounds = true
        selectionStyle = .none
        addSubviews(
            avatar,
            name,
            messageLabel,
            dateLabel,
            voteButton
        )
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()

        layout()
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        contentView.pin.width(size.width)
        layout()

        return CGSize(
            width: size.width,
            height: voteButton.frame.maxY + 12
        )
    }

    private func layout() {
        avatar.pin
            .size(avatarSize)
            .start(20)
            .top(12)

        name.pin
            .after(of: avatar)
            .marginStart(12)
            .sizeToFit()
            .top(to: avatar.edge.top)
            .marginTop(4)

        dateLabel.pin
            .after(of: name)
            .marginStart(8)
            .bottom(to: name.edge.bottom)
            .sizeToFit()

        messageLabel.pin
            .below(of: name, aligned: .left)
            .marginTop(8)
            .end(20)
            .sizeToFit(.width)

        voteButton.pin
            .below(of: messageLabel, aligned: .left)
            .marginTop(8)
            .height(18)
            .sizeToFit(.height)
            .start(to: messageLabel.edge.left)
    }

    func setup(_ message: Message) {
        self.model = message

        avatar.kf.setImage(with: try? message.user.avatar.asURL())
        name.text = message.user.name
        messageLabel.text = message.text
        dateLabel.text = message.createdTime.toDate.dateSinceNow
        voteButton.model = message
    }

}
