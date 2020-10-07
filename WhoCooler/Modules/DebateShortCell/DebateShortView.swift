//
//  DebateShortView.swift
//  WhoCooler
//
//  Created by Alex Nikolenko on 13.08.2020.
//  Copyright © 2020 Artem Trubacheev. All rights reserved.
//

import UIKit

class DebateShortView: UIView {

    // MARK: - Views
    let debateBottomContainer = DebateBottomContainer()
    private let leftImage = UIImageView().with {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 10
        $0.backgroundColor = UIColor(hex: 0xE6E6E6)
    }
    private let rightImage = UIImageView().with {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 10
        $0.backgroundColor = UIColor(hex: 0xE6E6E6)
    }
    private let middleSeparator = UIView().with {
        $0.backgroundColor = .lightGray
    }
    let moreButton = UIButton().with {
        $0.setImage(UIImage(named: "menu")?.withRenderingMode(.alwaysOriginal), for: .normal)
        $0.tintColor = .black
    }

    // MARK: - Properties
    private let leftSideColor = UIColor(hex: 0x29AB60)
    private let rightSideColor = UIColor(hex: 0xE74C3C)
    private var style: DebateCellStyle = .regular
    private var debateType: DebateType = .sides

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubviews(leftImage, middleSeparator, rightImage, debateBottomContainer)

        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize(width: 1, height: 1)
        layer.shadowOpacity = 1
        layer.shadowRadius = 4
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layout
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        pin.width(size.width)
        layout()

        return .init(
            width: size.width,
            height: debateBottomContainer.frame.maxY
        )
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        layout()
    }

    private func layout() {
        switch debateType {
        case .sides:
            sidesLayout()
        case .statement:
            statementLayout()
        }
    }

    private func sidesLayout() {
        rightImage.isHidden = false

        middleSeparator.pin
            .height(150)
            .hCenter()
            .top()
            .width(0.5)

        leftImage.pin
            .height(150)
            .start()
            .top(to: middleSeparator.edge.top)
            .before(of: middleSeparator)

        debateBottomContainer.pin
            .below(of: leftImage)
            .horizontally()
            .sizeToFit(.width)

        rightImage.pin
            .height(150)
            .top(to: middleSeparator.edge.top)
            .after(of: middleSeparator)
            .end()
    }

    private func statementLayout() {
        rightImage.isHidden = true

        leftImage.pin
            .height(225)
            .horizontally()
            .top()

        debateBottomContainer.pin
            .below(of: leftImage)
            .horizontally()
            .sizeToFit(.width)
    }

    // MARK: - Setup
    func setup(_ debate: Debate, style: DebateCellStyle = .regular) {
        self.style = style
        debateBottomContainer.debateInfoView.isHidden = style.isInfoViewHidden

        debateBottomContainer.debateName.text = debate.name
        debateBottomContainer.debateName.isHidden = debate.name == nil
        debateBottomContainer.style = style
        debateBottomContainer.backgroundColor = debate.debatePromotionType.backgroundColor

        debateBottomContainer.category.text = debate.debatePromotionType.shouldShowDebateOfDayText
            ? "debate.daily".localized.uppercased()
            : debate.category.name.uppercased()
        middleSeparator.isHidden = true

        switch debate.debateType {
        case .sides:
            leftImage.layer.maskedCorners = [.layerMinXMinYCorner]
            rightImage.layer.maskedCorners = [.layerMaxXMinYCorner]

            leftImage.kf.setImage(
                with: try? debate.leftSide.image?.asURL(),
                completionHandler: { [weak self] _ in
                    self?.middleSeparator.isHidden = false
                }
            )
            rightImage.kf.setImage(
                with: try? debate.rightSide.image?.asURL(),
                completionHandler: { [weak self] _ in
                    self?.middleSeparator.isHidden = false
                }
            )
        case .statement:
            leftImage.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            leftImage.kf.setImage(with: try? debate.image?.asURL())
        }

        debateType = debate.debateType

        debateBottomContainer.voteButton.setup(debate)
        debateBottomContainer.debateInfoView.setup(debate)

        debateBottomContainer.setNeedsLayout()

        setNeedsLayout()
    }

    func toggleFavorite() {
        debateBottomContainer.debateInfoView.toggleFavorite()
    }

}

private extension DebatePromotionType {

    var backgroundColor: UIColor {
        switch self {
        case .debateOfDay:
            return .init(white: 0.9, alpha: 1)
        case .none:
            return .white
        }
    }

    var shouldShowDebateOfDayText: Bool {
        switch self {
        case .debateOfDay:
            return true
        case .none:
            return false
        }
    }

}
