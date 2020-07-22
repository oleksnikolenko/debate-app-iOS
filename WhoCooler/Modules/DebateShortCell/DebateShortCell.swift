//
//  DebateShortCell.swift
//  DebateMaker
//
//  Created by Artem Trubacheev on 26.01.2020.
//  Copyright © 2020 Artem Trubacheev. All rights reserved.
//

import Kingfisher
import RxSwift

class DebateShortCell: TableViewCell {

    // MARK: - Subviews
    override var addableSubviews: [UIView] { [
        category,
        leftImage,
        debateName,
        voteButton,
        rightImage,
        middleSeparator,
        bottomSeparator,
        debateInfoView,
        moreButton
    ] }
    private let category = UILabel().with {
        $0.font = .boldSystemFont(ofSize: 14)
        $0.textAlignment = .left
        $0.textColor = .gray
    }
    private let leftImage = UIImageView().with {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 10
        $0.backgroundColor = UIColor(hex: 0xE6E6E6)
    }
    private let debateName = UILabel().with {
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.font = .systemFont(ofSize: 20, weight: .regular)
    }
    let voteButton = SideVoteButton()
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
    private let bottomSeparator = UIView().with {
        $0.backgroundColor = .lightGray
    }
    let debateInfoView = DebateInfoView()
    private let moreButton = UIButton().with {
        $0.setImage(UIImage(named: "menu")?.withRenderingMode(.alwaysOriginal), for: .normal)
        $0.tintColor = .black
    }

    // MARK: - Properties
    private let leftSideColor = UIColor(hex: 0x29AB60)
    private let rightSideColor = UIColor(hex: 0xE74C3C)
    private var style: DebateCellStyle = .regular
    private var debateType: DebateType = .sides
    var disposeBag = DisposeBag()
    var didClickFavorites: Observable<Void> {
        debateInfoView.favoritesImageView.didClick
    }
    var didClickLeft: Observable<Void> {
        Observable.merge(
            voteButton.leftName.didClick,
            voteButton.leftPercentLabel.didClick
        )
    }
    var didClickRight: Observable<Void> {
        Observable.merge(
            voteButton.rightName.didClick,
            voteButton.rightPercentLabel.didClick
        )
    }
    var didClickMoreButton: Observable<Void> {
        moreButton.didClick
    }

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Reuse
    override func prepareForReuse() {
        super.prepareForReuse()

        disposeBag = DisposeBag()
    }

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

        switch debateType {
        case .sides:
            sidesLayout()
        case .statement:
            statementLayout()
        }

        moreButton.pin
            .size(CGSize(width: 16, height: 16))
            .top(12)
            .end(20)

        if style == .regular {
            debateInfoView.pin
                .below(of: voteButton)
                .marginTop(20)
                .sizeToFit()
                .hCenter()
        }

        bottomSeparator.pin
            .horizontally()
            .height(2)
            .below(of: style == .regular ? debateInfoView : voteButton)
            .marginTop(style.separatorMargin)
    }

    private func sidesLayout() {
        rightImage.isHidden = false

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

        if !debateName.isHidden {
            debateName.pin
                .horizontally(40)
                .sizeToFit(.width)
                .below(of: leftImage)
                .marginTop(24)
        }

        voteButton.pin
            .horizontally(30)
            .sizeToFit(.width)
            .below(of: debateName.isHidden ? leftImage : debateName)
            .marginTop(24)

        rightImage.pin
            .height(150)
            .top(to: middleSeparator.edge.top)
            .after(of: middleSeparator)
            .end(10)
    }

    private func statementLayout() {
        rightImage.isHidden = true

        leftImage.pin
            .height(225)
            .horizontally(10)
            .marginTop(16)
            .below(of: category)

        if !debateName.isHidden {
            debateName.pin
                .horizontally(40)
                .sizeToFit(.width)
                .below(of: leftImage)
                .marginTop(24)
        }

        voteButton.pin
            .horizontally(30)
            .sizeToFit(.width)
            .below(of: debateName.isHidden ? leftImage : debateName)
            .marginTop(24)

    }

    // MARK: - Setup
    func setup(_ debate: Debate, style: DebateCellStyle = .regular) {
        self.style = style
        debateInfoView.isHidden = style.isInfoViewHidden

        debateName.text = debate.name
        debateName.isHidden = debate.name == nil

        category.text = debate.category.name
        middleSeparator.isHidden = true

        switch debate.debateType {
        case .sides:
            leftImage.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
            rightImage.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]

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
            leftImage.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner, .layerMaxXMaxYCorner, .layerMaxXMinYCorner]
            leftImage.kf.setImage(with: try? debate.image?.asURL())
        }

        debateType = debate.debateType

        voteButton.setup(debate)
        debateInfoView.setup(debate)

        setNeedsLayout()
    }

    func toggleFavorite() {
        debateInfoView.toggleFavorite()
    }

}
