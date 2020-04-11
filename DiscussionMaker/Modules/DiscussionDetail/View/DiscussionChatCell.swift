//
//  DiscussionChatCell.swift
//  DiscussionMaker
//
//  Created by Artem Trubacheev on 11.04.2020.
//  Copyright © 2020 Artem Trubacheev. All rights reserved.
//

import UIKit

class DiscussionChatCell: UITableViewCell {

    // MARK: - Subviews
    let avatar = UIImageView()
    let name = UILabel()
    let messageLabel = UILabel()

    // MARK: - Properties
    var model: Message?

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        addSubviews(
            avatar,
            name,
            messageLabel
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
            height: messageLabel.frame.maxY + 16
        )
    }

    private func layout() {
        avatar.pin
            .size(48)
            .topStart(16)

        name.pin
            .after(of: avatar)
            .marginStart(8)
            .right()
            .sizeToFit(.width)
            .top(8)

        messageLabel.pin
            .below(of: name, aligned: .left)
            .marginTop(8)
            .start(to: name.edge.start)
            .right()
            .sizeToFit(.width)
    }

    func setup(_ message: Message) {
        self.model = message

       // avatar.kf.setImage(with: nil)
        name.text = message.user.name
        messageLabel.text = message.text
    }

}
