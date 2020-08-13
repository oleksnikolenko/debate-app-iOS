//
//  DebateBottomContainer.swift
//  WhoCooler
//
//  Created by Alex Nikolenko on 13.08.2020.
//  Copyright © 2020 Artem Trubacheev. All rights reserved.
//

import UIKit

class DebateBottomContainer: UIView {

    // MARK: - Subviews
    let debateName = UILabel().with {
        $0.numberOfLines = 0
        $0.textAlignment = .left
        $0.font = .systemFont(ofSize: 24, weight: .bold)
    }
    let voteButton = SideVoteButton()
    let debateInfoView = DebateInfoView()
    let category = UILabel().with {
        $0.font = .boldSystemFont(ofSize: 14)
        $0.textAlignment = .left
        $0.textColor = .gray
        $0.backgroundColor = .white
    }

    // MARK: - Properties
    var style: DebateCellStyle = .regular

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubviews(category, debateName, voteButton, debateInfoView)

        layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        layer.cornerRadius = 10
        backgroundColor = .white
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()

        layout()
    }

    private func layout() {
        category.pin
            .horizontally(16)
            .top()
            .sizeToFit(.width)
            .marginTop(12)

        if !debateName.isHidden {
            debateName.pin
                .horizontally(16)
                .sizeToFit(.width)
                .below(of: category)
                .marginTop(12)

            voteButton.pin
                .horizontally(16)
                .sizeToFit(.width)
                .below(of: debateName)
                .marginTop(24)
        } else {
            voteButton.pin
                .horizontally(16)
                .sizeToFit(.width)
                .below(of: category)
                .marginTop(12)
        }

        if style == .regular {
            debateInfoView.pin
                .below(of: voteButton)
                .marginTop(20)
                .sizeToFit()
                .hCenter()
        }
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        pin.width(size.width)
        layout()

        return CGSize(
            width: size.width,
            height: (style == .regular ? debateInfoView.frame.maxY + 12 : voteButton.frame.maxY + 20)
        )
    }

}
