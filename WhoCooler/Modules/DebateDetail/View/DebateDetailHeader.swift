//
//  DebateDetailHeader.swift
//  DebateMaker
//
//  Created by Artem Trubacheev on 11.04.2020.
//  Copyright © 2020 Artem Trubacheev. All rights reserved.
//

import Kingfisher
import PinLayout
import UIKit

enum VoteSide {
    case left
    case right
}

class DebateDetailHeader: UIView {

    // MARK: Subviews
    let shade = UIView().with {
        $0.backgroundColor = .black
        $0.alpha = 0.15
        $0.isUserInteractionEnabled = false
    }
    let leftImage = UIImageView().with {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.masksToBounds = true
    }
    let rightImage = UIImageView().with {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.masksToBounds = true
    }
    let voteButton = SideVoteButton()
    let middleSeparator = UIView().with {
        $0.backgroundColor = .lightGray
    }
    let messageLabel = UILabel().with {
        $0.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        // TODO: - Localize
        $0.text = "Comments"
    }
    let messageCounter = UILabel().with {
        $0.textColor = .lightGray
        $0.font =  UIFont.systemFont(ofSize: 16, weight: .semibold)
    }

    // MARK: - Properties
    private let middleSeparatorWidth: CGFloat = 0.5

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubviews(
            leftImage,
            voteButton,
            middleSeparator,
            rightImage,
            shade,
            messageLabel,
            messageCounter
        )
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layout
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        layout()

        return .init(
            width: size.width,
            height: messageLabel.frame.maxY + 4
        )
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        layout()
    }

    private func layout() {
        UIView.animate(withDuration: 0.5) {
            self.shade.pin
                .horizontally()
                .height(150)
                .top()

            self.middleSeparator.pin
                .height(150)
                .hCenter()
                .top()
                .width(self.middleSeparatorWidth)

            self.leftImage.pin
                .height(150)
                .start()
                .top(to: self.middleSeparator.edge.top)
                .before(of: self.middleSeparator)

            self.voteButton.pin
                .horizontally(20)
                .sizeToFit(.width)
                .below(of: self.leftImage)
                .marginTop(24)

            self.rightImage.pin
                .height(150)
                .top(to: self.middleSeparator.edge.top)
                .after(of: self.middleSeparator)
                .end()

            self.messageLabel.pin
                .below(of: self.voteButton)
                .start(20)
                .sizeToFit()
                .marginTop(16)

            self.messageCounter.pin
                .after(of: self.messageLabel, aligned: .center)
                .marginStart(12)
                .sizeToFit()
        }
    }

    // MARK: - Public methods
    func setup(debate: Debate) {
        leftImage.kf.setImage(with: try? debate.leftSide.image.asURL())
        rightImage.kf.setImage(with: try? debate.rightSide.image.asURL())

        UIView.animate(withDuration: 0.5) {
            self.voteButton.setup(debate)
            self.messageCounter.text = debate.messagesList.messages.count.description
            self.layoutIfNeeded()
        }
    }

}
