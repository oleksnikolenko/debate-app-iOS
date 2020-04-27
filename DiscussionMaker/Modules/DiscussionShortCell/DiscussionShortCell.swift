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
        category,
        leftImage,
        leftButton,
        rightImage,
        rightButton,
        middleSeparator,
        bottomSeparator,
        discussionInfoView
    ] }
    let category = UILabel().with {
        $0.font = .boldSystemFont(ofSize: 14)
        $0.textAlignment = .left
        $0.textColor = .gray
    }
    let leftImage = UIImageView().with {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.masksToBounds = true
        if #available(iOS 11.0, *) {
            $0.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
            $0.layer.cornerRadius = 10
        }
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
        if #available(iOS 11.0, *) {
            $0.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
            $0.layer.cornerRadius = 7
        }
    }
    let rightImage = UIImageView().with {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.masksToBounds = true
        if #available(iOS 11.0, *) {
            $0.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
            $0.layer.cornerRadius = 10
        }
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
        if #available(iOS 11.0, *) {
            $0.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
            $0.layer.cornerRadius = 7
        }
    }
    let middleSeparator = UIView().with {
        $0.backgroundColor = .lightGray
    }
    let bottomSeparator = UIView().with {
        $0.backgroundColor = .lightGray
    }
    let discussionInfoView = DiscussionInfoView()

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Properties
    let leftSideColor = UIColor(hex: 0x29AB60)
    let rightSideColor = UIColor(hex: 0xE74C3C)

    // MARK: - Layout
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        layout()

        return .init(
            width: size.width,
            height: bottomSeparator.frame.maxY
        )
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        layout()
    }

    override func layout() {
        category.pin
            .topStart(12)
            .end(12)
            .sizeToFit(.width)

        middleSeparator.pin
            .height(150)
            .hCenter()
            .below(of: category)
            .marginTop(16)
            .width(0.5)

        leftImage.pin
            .height(150)
            .start(10)
            .top(to: middleSeparator.edge.top)
            .before(of: middleSeparator)

        leftButton.pin
            .below(of: leftImage)
            .start(30)
            .height(40)
            .marginTop(24)
            .end(to: middleSeparator.edge.left)

        rightImage.pin
            .height(150)
            .top(to: middleSeparator.edge.top)
            .after(of: middleSeparator)
            .end(10)

        rightButton.pin
            .below(of: rightImage)
            .end(30)
            .height(40)
            .marginTop(24)
            .start(to: middleSeparator.edge.right)

        discussionInfoView.pin
            .below(of: rightButton)
            .marginTop(20)
            .sizeToFit()
            .hCenter()

        bottomSeparator.pin
            .horizontally()
            .height(2)
            .below(of: discussionInfoView)
            .marginTop(12)

    }

    // MARK: - Setup
    func setup(_ discussion: Discussion) {
        category.text = discussion.category.name

        leftImage.kf.setImage(with: try? discussion.leftSide.image.asURL())
        leftButton.setTitle(discussion.leftSide.name, for: .normal)

        rightButton.setTitle(discussion.rightSide.name, for: .normal)
        rightImage.kf.setImage(with: try? discussion.rightSide.image.asURL())

        discussionInfoView.setup(discussion)

        setNeedsLayout()
    }

}
