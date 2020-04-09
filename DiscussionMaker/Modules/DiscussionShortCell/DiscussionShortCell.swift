//
//  DiscussionShortCell.swift
//  DiscussionMaker
//
//  Created by Artem Trubacheev on 26.01.2020.
//  Copyright © 2020 Artem Trubacheev. All rights reserved.
//

import UIKit
import SUHelpers
import Kingfisher

class DiscussionShortCell: TableViewCell {

    // MARK: - Subviews
    override var addableSubviews: [UIView] { [
        title,
        leftImage,
        leftName,
        leftRating,
        rightImage,
        rightName,
        rightRating
    ] }
    let title = UILabel().with {
        $0.font = .boldSystemFont(ofSize: 14)
        $0.textAlignment = .center
    }
    let leftImage = UIImageView()
    let leftName = UILabel().with {
        $0.textAlignment = .left
    }
    let leftRating = UILabel().with {
        $0.textAlignment = .left
    }
    let rightImage = UIImageView()
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

        leftImage.pin
            .size(48)
            .topStart(8)

        leftName.pin
            .sizeToFit()
            .start(8)
            .below(of: leftImage)
            .marginTop(24)

        leftRating.pin
            .sizeToFit()
            .below(of: leftName, aligned: .start)

        rightImage.pin
            .size(48)
            .topEnd(8)

        rightName.pin
            .sizeToFit()
            .end(8)
            .below(of: rightImage)
            .marginTop(24)

        rightRating.pin
            .sizeToFit()
            .below(of: rightName, aligned: .end)
    }

    // MARK: - Setup
    func setup(_ discussion: Discussion) {
        title.text = discussion.name

        leftImage.kf.setImage(with: try? discussion.leftSide.image.asURL())
        leftName.text = discussion.leftSide.name
        leftRating.text = discussion.leftSide.ratingCount.description

        rightImage.kf.setImage(with: try? discussion.rightSide.image.asURL())
        rightName.text = discussion.rightSide.name
        rightRating.text = discussion.rightSide.ratingCount.description

        setNeedsLayout()
    }

}
