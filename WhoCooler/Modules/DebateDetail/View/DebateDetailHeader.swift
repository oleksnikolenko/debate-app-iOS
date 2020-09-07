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
    private let debateName = UILabel().with {
        $0.numberOfLines = 0
        $0.textAlignment = .left
        $0.font = .systemFont(ofSize: 24, weight: .bold)
    }
    let voteButton = SideVoteButton()
    let middleSeparator = UIView().with {
        $0.backgroundColor = .lightGray
    }
    let messageLabel = UILabel().with {
        $0.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        $0.text = "message.header".localized
    }
    let messageCounter = UILabel().with {
        $0.textColor = .lightGray
        $0.font =  UIFont.systemFont(ofSize: 16, weight: .semibold)
    }

    // MARK: - Properties
    private let middleSeparatorWidth: CGFloat = 0.5
    private var debateType: DebateType = .sides

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubviews(
            leftImage,
            voteButton,
            debateName,
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
        switch debateType {
        case .sides:
            sidesLayout()
        case .statement:
            statementLayout()
        }

        return .init(
            width: size.width,
            height: messageLabel.frame.maxY + 4
        )
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        switch debateType {
        case .sides:
            sidesLayout()
        case .statement:
            statementLayout()
        }
    }

    private func sidesLayout() {
        rightImage.isHidden = false
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

        if !self.debateName.isHidden {
            self.debateName.pin
                .horizontally(20)
                .sizeToFit(.width)
                .below(of: self.leftImage)
                .marginTop(24)
        }

        self.voteButton.pin
            .horizontally(20)
            .sizeToFit(.width)
            .below(of: self.debateName.isHidden ? self.leftImage : self.debateName)
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

    private func statementLayout() {
        rightImage.isHidden = true
        self.shade.pin
            .horizontally()
            .height(225)
            .top()

        self.leftImage.pin
            .height(225)
            .horizontally()
            .top()

        if !self.debateName.isHidden {
            self.debateName.pin
                .horizontally(20)
                .sizeToFit(.width)
                .below(of: self.leftImage)
                .marginTop(24)
        }

        self.voteButton.pin
            .horizontally(20)
            .sizeToFit(.width)
            .below(of: self.debateName.isHidden ? self.leftImage : self.debateName)
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

        middleSeparator.pin
            .height(0)
            .hCenter()
            .top()
            .width(0)
    }

    // MARK: - Public methods
    func setup(debate: Debate) {
        debateType = debate.debateType

        switch debateType {
        case .sides:
            leftImage.kf.setImage(with: try? debate.leftSide.image?.asURL())
            rightImage.kf.setImage(with: try? debate.rightSide.image?.asURL())
        case .statement:
            leftImage.kf.setImage(with: try? debate.image?.asURL())
        }

        debateName.text = debate.name
        debateName.isHidden = debate.name == nil

        UIView.animate(withDuration: 0.5) {
            self.voteButton.setup(debate)
            self.messageCounter.text = debate.messageCount.description
            self.layoutIfNeeded()
        }
    }

    func updateVotes(debate: Debate) {
        UIView.animate(withDuration: 0.5) {
            self.voteButton.setup(debate)
            self.layoutIfNeeded()
        }
    }

    func updateMessageCounter(value: Int) {
        guard
            let messageCounterText = messageCounter.text,
            let currentMessageCount = Int(messageCounterText)
        else { return }

        let newMessageCount = currentMessageCount + value
        messageCounter.text = newMessageCount.description

        setNeedsLayout()
    }

}
