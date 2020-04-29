//
//  SideVoteButton.swift
//  DiscussionMaker
//
//  Created by Alex Nikolenko on 29/04/2020.
//  Copyright © 2020 Artem Trubacheev. All rights reserved.
//

import SUHelpers
import UIKit

class SideVoteButton: UIView {

    // MARK: - Subviews
    let leftName = GradientLabel().with {
        $0.font = UIFont.systemFont(ofSize: 22, weight: .light)
        $0.numberOfLines = 2
        $0.adjustsFontSizeToFitWidth = true
        $0.textAlignment = .center
        $0.isUserInteractionEnabled = true
        $0.gradientColors = [UIColor(hex: 0x00F260).cgColor, UIColor(hex:0x0575E6).cgColor]
    }
    let leftPercentLabel = UILabel().with {
        $0.font = UIFont.systemFont(ofSize: 18, weight: .light)
        $0.numberOfLines = 1
        $0.textAlignment = .center
        $0.isUserInteractionEnabled = true
    }
    let rightName = GradientLabel().with {
        $0.font = UIFont.systemFont(ofSize: 22, weight: .light)
        $0.numberOfLines = 2
        $0.adjustsFontSizeToFitWidth = true
        $0.textAlignment = .center
        $0.isUserInteractionEnabled = true
        $0.gradientColors = [UIColor(hex: 0xDC2424).cgColor, UIColor(hex:0x4A569D).cgColor]
    }
    let rightPercentLabel = UILabel().with {
        $0.font = UIFont.systemFont(ofSize: 18, weight: .light)
        $0.numberOfLines = 1
        $0.textAlignment = .center
        $0.isUserInteractionEnabled = true
    }
    let votedShade = UIView().with {
        $0.backgroundColor = UIColor(hex: 0xE6E6E6)
        $0.isHidden = true
        $0.layer.cornerRadius = 14
    }
    let middleSeparator = UIView().with {
        $0.backgroundColor = .lightGray
    }

    // MARK: - Properties
    private let viewHeight: CGFloat = 64
    private var userChosenSide: SideType = .left
    private var leftPercent: Int = 0
    private var rightPercent: Int = 0
    private var style: SideVoteStyle = .nonVoted

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubviews(votedShade, leftName, leftPercentLabel, rightName, rightPercentLabel, middleSeparator)
        setupStyle()
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
        pin.width(size.width)
        layout()

        return CGSize(width: size.width, height: viewHeight)
    }

    private func layout() {
        switch style {
        case .nonVoted:
            nonVotedLayout()
        case .voted:
            votedLayout()
        case .singleWinner:
            singleWinnerLayout()
        }
    }

    private func nonVotedLayout() {
        votedShade.pin.all()

        middleSeparator.pin
            .top()
            .height(viewHeight)
            .width(0.5)
            .hCenter()

        leftName.pin
            .start(4)
            .end(to: middleSeparator.edge.left)
            .sizeToFit(.width)
            .vCenter()

        rightName.pin
            .start(to: middleSeparator.edge.right)
            .end(4)
            .sizeToFit(.width)
            .vCenter()
    }

    private func votedLayout() {
        votedShade.isHidden = false
        middleSeparator.isHidden = true

        if userChosenSide == .left {
            leftVotedLayout()
        } else {
            rightVotedLayout()
        }
    }

    private func leftVotedLayout() {
        let votedShadeLength = min(frame.width * CGFloat(leftPercent) / 100, frame.width * 4 / 5)

        votedShade.pin
            .start()
            .width(votedShadeLength)
            .height(viewHeight)
            .top()

        leftPercentLabel.pin
            .bottom()
            .start(4)
            .end(to: votedShade.edge.right)
            .sizeToFit(.width)
            .marginVertical(4)

        leftName.pin
            .above(of: leftPercentLabel)
            .top()
            .start(4)
            .end(to: votedShade.edge.right)
            .marginHorizontal(4)

        rightPercentLabel.pin
            .bottom()
            .start(to: votedShade.edge.right)
            .end(4)
            .sizeToFit(.width)
            .marginVertical(4)

        rightName.pin
            .above(of: rightPercentLabel)
            .end(4)
            .start(to: votedShade.edge.right)
            .top()
            .marginHorizontal(4)
    }

    private func rightVotedLayout() {
        let votedShadeLength = min(frame.width * CGFloat(rightPercent) / 100, frame.width * 4 / 5)

        votedShade.pin
            .width(votedShadeLength)
            .end()
            .height(viewHeight)
            .top()

        leftPercentLabel.pin
            .bottom()
            .start(4)
            .end(to: votedShade.edge.left)
            .sizeToFit(.width)
            .marginVertical(4)

        leftName.pin
            .above(of: leftPercentLabel)
            .top()
            .start(4)
            .end(to: votedShade.edge.left)
            .marginHorizontal(4)

        rightPercentLabel.pin
            .bottom()
            .start(to: votedShade.edge.left)
            .end(4)
            .sizeToFit(.width)
            .marginVertical(4)

        rightName.pin
            .above(of: rightPercentLabel)
            .end()
            .start(to: votedShade.edge.left)
            .marginHorizontal(4)
            .top()
    }

    private func singleWinnerLayout() {
        votedShade.isHidden = true

        if userChosenSide == .left {
            rightName.isHidden = true
            rightPercentLabel.isHidden = true

            leftPercentLabel.pin
                .bottom()
                .start(4)
                .end(4)
                .sizeToFit(.width)
                .marginVertical(4)

            leftName.pin
                .above(of: leftPercentLabel)
                .top()
                .start(4)
                .end()
        } else {
            leftName.isHidden = true
            leftPercentLabel.isHidden = true

            rightPercentLabel.pin
                .bottom()
                .start(4)
                .end(4)
                .sizeToFit(.width)
                .marginVertical(4)

            rightName.pin
                .above(of: rightPercentLabel)
                .top()
                .start(4)
                .end()
        }
    }

    // MARK: - Public methods
    func setup(_ debate: Discussion) {
        guard debate.leftSide.isVotedByUser || debate.rightSide.isVotedByUser
        else {
            nonVotedSetup(debate)
            return
        }

        toggleHidingViews(isVoted: true)

        leftPercent = debate.leftSidePercents
        rightPercent = debate.rightSidePercents

        if debate.leftSide.isVotedByUser {
            userChosenSide = .left
            setupShadeCornerRadius(.left)
        } else if debate.rightSide.isVotedByUser {
            userChosenSide = .right
            setupShadeCornerRadius(.right)
        }

        if leftPercent == 100 || rightPercent == 100 {
            style = .singleWinner
        } else {
            style = .voted
        }

        leftName.text = debate.leftSide.name
        leftPercentLabel.text = leftPercent.description + "%"

        rightName.text = debate.rightSide.name
        rightPercentLabel.text = rightPercent.description + "%"

        setNeedsLayout()
    }

    // MARK: - Private Methods
    private func setupStyle() {
        backgroundColor = .white
        layer.cornerRadius = 14
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize(width: 1, height: 1)
        layer.shadowOpacity = 1
        layer.shadowRadius = 10
        layer.masksToBounds = false
    }

    private func setupShadeCornerRadius(_ side: SideType) {
        switch side {
        case .left:
            votedShade.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
        case .right:
            votedShade.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        }
    }

    private func nonVotedSetup(_ debate: Discussion) {
        style = .nonVoted

        leftName.isHidden = false
        rightName.isHidden = false

        toggleHidingViews(isVoted: false)

        leftName.text = debate.leftSide.name
        rightName.text = debate.rightSide.name

        setNeedsLayout()
    }

    private func toggleHidingViews(isVoted: Bool) {
        middleSeparator.isHidden = isVoted
        votedShade.isHidden = !isVoted
        leftPercentLabel.isHidden = !isVoted
        rightPercentLabel.isHidden = !isVoted
    }

}
