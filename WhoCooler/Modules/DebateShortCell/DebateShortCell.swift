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
        voteButton,
        rightImage,
        middleSeparator,
        bottomSeparator,
        debateInfoView
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
        $0.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
        $0.layer.cornerRadius = 10
    }
    let voteButton = SideVoteButton()
    let rightImage = UIImageView().with {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.masksToBounds = true
        $0.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        $0.layer.cornerRadius = 10
    }
    let middleSeparator = UIView().with {
        $0.backgroundColor = .lightGray
    }
    let bottomSeparator = UIView().with {
        $0.backgroundColor = .lightGray
    }
    let debateInfoView = DebateInfoView()

    // MARK: - Properties
    private let leftSideColor = UIColor(hex: 0x29AB60)
    private let rightSideColor = UIColor(hex: 0xE74C3C)
    private var style: DebateCellStyle = .regular
    var isFavorite: Bool = false {
        didSet {
            debateInfoView.isFavorite = !debateInfoView.isFavorite
        }
    }
    var disposeBag = DisposeBag()
    var didClickFavorites: Observable<Void> {
        debateInfoView.favoritesImageView.didClick
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

        voteButton.pin
            .horizontally(30)
            .sizeToFit(.width)
            .below(of: leftImage)
            .marginTop(24)

        rightImage.pin
            .height(150)
            .top(to: middleSeparator.edge.top)
            .after(of: middleSeparator)
            .end(10)

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

    // MARK: - Setup
    func setup(_ Debate: Debate, style: DebateCellStyle = .regular) {
        self.style = style
        debateInfoView.isHidden = style.isInfoViewHidden

        category.text = Debate.category.name
        isFavorite = Debate.isFavorite

        leftImage.kf.setImage(with: try? Debate.leftSide.image.asURL())
        rightImage.kf.setImage(with: try? Debate.rightSide.image.asURL())

        voteButton.setup(Debate)
        debateInfoView.setup(Debate)

        setNeedsLayout()
    }

    func toggleFavorite() {
        isFavorite = !isFavorite
    }

}
