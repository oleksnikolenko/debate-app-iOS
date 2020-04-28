//
//  DiscussionDetailHeader.swift
//  DiscussionMaker
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

class DiscussionDetailHeader: UIView {

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
    lazy var leftButton = UIButton().with {
        $0.backgroundColor = .white
        $0.layer.shadowColor = UIColor.lightGray.cgColor
        // Offset - 1 to be symmetric with right button which has +1 offset
        $0.layer.shadowOffset = CGSize(width: -1, height: 1)
        $0.layer.shadowOpacity = 1
        $0.layer.shadowRadius = 2
        $0.layer.masksToBounds = false
        $0.titleLabel?.numberOfLines = 3
        $0.titleLabel?.adjustsFontSizeToFitWidth = true
        $0.titleLabel?.textAlignment = .center
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        $0.setTitleColor(leftSideColor, for: .normal)
        $0.layer.maskedCorners = defaultLeftMaskedCorners
        $0.layer.cornerRadius = 7
    }
    let rightImage = UIImageView().with {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.masksToBounds = true
    }
    lazy var rightButton = UIButton().with {
        $0.backgroundColor = .white
        $0.layer.shadowColor = UIColor.lightGray.cgColor
        $0.layer.shadowOffset = CGSize(width: 1, height: 1)
        $0.layer.shadowOpacity = 1
        $0.layer.shadowRadius = 2
        $0.layer.masksToBounds = false
        $0.titleLabel?.numberOfLines = 3
        $0.titleLabel?.adjustsFontSizeToFitWidth = true
        $0.titleLabel?.textAlignment = .center
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        $0.setTitleColor(rightSideColor, for: .normal)
        $0.layer.maskedCorners = defaultRightMaskedCorners
        $0.layer.cornerRadius = 7
    }
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
    private let leftSideColor = UIColor(hex: 0x29AB60)
    private let rightSideColor = UIColor(hex: 0xE74C3C)
    private let buttonHorizontalMargin: CGFloat = 30
    private var availableSpaceForButtons: CGFloat {
        frame.width - 2 * buttonHorizontalMargin - middleSeparatorWidth
    }
    private let middleSeparatorWidth: CGFloat = 0.5
    private var leftButtonWidth: CGFloat?
    private var rightButtonWidth: CGFloat?
    private let defaultLeftMaskedCorners: CACornerMask = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
    private let defaultRightMaskedCorners: CACornerMask = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
    private let allMaskedCorners: CACornerMask = [
        .layerMinXMinYCorner,
        .layerMinXMaxYCorner,
        .layerMaxXMaxYCorner,
        .layerMaxXMinYCorner
    ]

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubviews(
            leftImage,
            leftButton,
            middleSeparator,
            rightImage,
            rightButton,
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

            self.leftButton.pin
                .below(of: self.leftImage)
                .start(self.buttonHorizontalMargin)
                .height(40)
                .marginTop(24)
                .width(self.leftButtonWidth ?? self.availableSpaceForButtons / 2)

            self.rightImage.pin
                .height(150)
                .top(to: self.middleSeparator.edge.top)
                .after(of: self.middleSeparator)
                .end()

            self.rightButton.pin
                .below(of: self.rightImage)
                .end(self.buttonHorizontalMargin)
                .height(40)
                .marginTop(24)
                .width(self.rightButtonWidth ?? self.availableSpaceForButtons / 2)

            self.messageLabel.pin
                .below(of: self.leftButton)
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
    func setup(debate: Discussion) {
        leftImage.kf.setImage(with: try? debate.leftSide.image.asURL())
        rightImage.kf.setImage(with: try? debate.rightSide.image.asURL())

        UIView.animate(withDuration: 0.5) {
            self.setupButtons(debate)
            self.messageCounter.text = debate.messagesList.messages.count.description
            self.layoutIfNeeded()
        }
    }

    // MARK: - Private methods
    private func setupButtons(_ debate: Discussion) {
        if debate.leftSide.isVotedByUser || debate.rightSide.isVotedByUser  {
            let leftSidePercent = Int(Double(debate.leftSide.ratingCount) / Double(debate.votesCount) * 100)
            let leftSideText = debate.leftSide.name + "\n" + leftSidePercent.description + "%"

            let rightSidePercent = 100 - leftSidePercent
            let rightSideText = debate.rightSide.name + "\n" + rightSidePercent.description + "%"

            leftButton.setTitle(leftSideText, for: .normal)
            rightButton.setTitle(rightSideText, for: .normal)

            layoutVotedButton(
                side: debate.leftSide.isVotedByUser ? .left : .right,
                leftPercent: leftSidePercent,
                rightPercent: rightSidePercent
            )
        } else {
            defaultSetupForLeftButton(debate)
            defaultSetupForRightButton(debate)
        }
    }

    private func defaultSetupForLeftButton(_ debate: Discussion) {
        leftButtonWidth = availableSpaceForButtons / 2
        leftButton.backgroundColor = .white
        leftButton.setTitleColor(leftSideColor, for: .normal)
        leftButton.setTitle(debate.leftSide.name, for: .normal)
        leftButton.layer.maskedCorners = defaultLeftMaskedCorners
    }

    private func defaultSetupForRightButton(_ debate: Discussion) {
        rightButtonWidth = availableSpaceForButtons / 2
        rightButton.backgroundColor = .white
        rightButton.setTitleColor(rightSideColor, for: .normal)
        rightButton.setTitle(debate.rightSide.name, for: .normal)
        rightButton.layer.maskedCorners = defaultRightMaskedCorners
    }

    private func layoutVotedButton(side: VoteSide, leftPercent: Int, rightPercent: Int) {
        leftButtonWidth = availableSpaceForButtons * CGFloat(leftPercent) / 100
        rightButtonWidth = availableSpaceForButtons * CGFloat(rightPercent) / 100

        if leftPercent == 100 {
            leftButton.layer.maskedCorners = allMaskedCorners
        } else if rightPercent == 100 {
            rightButton.layer.maskedCorners = allMaskedCorners
        }

        switch side {
        case .left:
            setupLeftVotedSide()
        case .right:
            setupRightVotedSide()
        }
    }

    private func setupLeftVotedSide() {
        leftButton.backgroundColor = .blue
        leftButton.setTitleColor(.white, for: .normal)

        rightButton.backgroundColor = .white
        rightButton.setTitleColor(.black, for: .normal)
    }

    private func setupRightVotedSide() {
        rightButton.backgroundColor = .blue
        rightButton.setTitleColor(.white, for: .normal)

        leftButton.backgroundColor = .white
        leftButton.setTitleColor(.black, for: .normal)
    }

}
