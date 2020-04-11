//
//  DiscussionDetailHeader.swift
//  DiscussionMaker
//
//  Created by Artem Trubacheev on 11.04.2020.
//  Copyright © 2020 Artem Trubacheev. All rights reserved.
//

import UIKit
import PinLayout

class DiscussionDetailHeader: UIView {

    // MARK: Subviews
    let shade = UIView().with {
        $0.backgroundColor = .black
        $0.alpha = 0.15
    }

    let leftSidePhoto = UIImageView().with {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    let leftName = UILabel().with {
        $0.textColor = .white
        $0.font = .boldSystemFont(ofSize: 24)
        $0.numberOfLines = 0
    }
    let leftVotes = UILabel().with {
        $0.textColor = .white
    }

    let rightSidePhoto = UIImageView().with {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    let rightName = UILabel().with {
        $0.textColor = .white
        $0.font = .boldSystemFont(ofSize: 24)
        $0.textAlignment = .right
        $0.numberOfLines = 0
    }
    let rightVotes = UILabel().with {
        $0.textColor = .white
        $0.textAlignment = .right
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubviews(
            leftSidePhoto,
            rightSidePhoto,
            shade,
            leftName,
            leftVotes,
            rightName,
            rightVotes
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
            height: rightName.frame.maxY + 8
        )
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        layout()
    }

    private func layout() {
        shade.pin
            .horizontally()
            .height(150)
            .top()

        leftSidePhoto.pin
            .topStart()
            .height(150)
            .width(50%)

        leftVotes.pin
            .width(45%)
            .sizeToFit(.width)
            .start(8)
            .bottom(to: leftSidePhoto.edge.bottom)
            .marginBottom(8)

        leftName.pin
            .width(45%)
            .sizeToFit(.width)
            .start(8)
            .above(of: leftVotes)
            .marginBottom(8)

        rightSidePhoto.pin
            .topEnd()
            .height(150)
            .width(50%)

        rightVotes.pin
            .width(45%)
            .sizeToFit(.width)
            .end(8)
            .bottom(to: rightSidePhoto.edge.bottom)
            .marginBottom(8)

        rightName.pin
            .width(45%)
            .sizeToFit(.width)
            .end(8)
            .above(of: rightVotes)
            .marginBottom(8)
    }

    func setup(debate: Discussion) {
           let leftSide = debate.leftSide
           leftSidePhoto.kf.setImage(with: try? leftSide.image.asURL())
           leftName.text = leftSide.name
           leftVotes.text = leftSide.ratingCount.description

           let rightSide = debate.rightSide
           rightSidePhoto.kf.setImage(with: try? rightSide.image.asURL())
           rightName.text = rightSide.name
           rightVotes.text = rightSide.ratingCount.description

           setNeedsLayout()
       }
    
}
