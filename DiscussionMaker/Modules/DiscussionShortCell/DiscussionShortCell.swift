//
//  DiscussionShortCell.swift
//  DiscussionMaker
//
//  Created by Artem Trubacheev on 26.01.2020.
//  Copyright © 2020 Artem Trubacheev. All rights reserved.
//

import UIKit
import SUHelpers

class DiscussionShortCell: TableViewCell {

    // MARK: - Subviews
    override var addableSubviews: [UIView] { [
        title,
        leftName,
        rightName,
        leftRating,
        rightRating
    ] }
    let title = UILabel().with {
        $0.font = .boldSystemFont(ofSize: 14)
        $0.textAlignment = .center
    }
    let leftName = UILabel().with {
        $0.textAlignment = .left
    }
    let leftRating = UILabel().with {
        $0.textAlignment = .left
    }
    let rightName = UILabel().with {
        $0.textAlignment = .left
    }
    let rightRating = UILabel().with {
        $0.textAlignment = .left
    }

    // MARK: - Layout
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        layout()

        return .init(
            width: size.width,
            height: rightRating.frame.maxY + 8
        )
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        layout()
    }

    override func layout() {
        title.pin
            .horizontally()
            .sizeToFit(.width)
            .top(8)

        leftName.pin
            .sizeToFit()
            .start(8)
            .top(24)

        leftRating.pin
            .sizeToFit()
            .below(of: leftName, aligned: .start)

        rightName.pin
            .sizeToFit()
            .end(8)
            .top(24)

        rightRating.pin
            .sizeToFit()
            .below(of: rightName, aligned: .end)
    }

    // MARK: - Setup
    func setup(_ discussion: Discussion) {
        title.text = discussion.name

        leftName.text = discussion.leftSide.name
        leftRating.text = discussion.leftSide.ratingCount.description

        rightName.text = discussion.rightSide.name
        rightRating.text = discussion.rightSide.ratingCount.description

        setNeedsLayout()
    }

}
