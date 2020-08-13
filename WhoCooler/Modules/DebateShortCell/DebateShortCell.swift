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
        debateShortView
    ] }
    let debateShortView = DebateShortView()

    // MARK: - Properties

    var disposeBag = DisposeBag()
    var didClickFavorites: Observable<Void> {
        debateShortView.debateBottomContainer.debateInfoView.favoritesImageView.didClick
    }
    var didClickLeft: Observable<Void> {
        Observable.merge(
            debateShortView.debateBottomContainer.voteButton.leftName.didClick,
            debateShortView.debateBottomContainer.voteButton.leftPercentLabel.didClick
        )
    }
    var didClickRight: Observable<Void> {
        Observable.merge(
            debateShortView.debateBottomContainer.voteButton.rightName.didClick,
            debateShortView.debateBottomContainer.voteButton.rightPercentLabel.didClick
        )
    }
    var didClickMoreButton: Observable<Void> {
        debateShortView.moreButton.didClick
    }

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = .clear
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
        pin.width(size.width)
        layout()

        return .init(
            width: size.width,
            height: debateShortView.frame.maxY
        )
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        layout()
    }

    override func layout() {
        debateShortView.pin
            .top(20)
            .horizontally(12)
            .sizeToFit(.width)
    }

    // MARK: - Setup
    func setup(_ debate: Debate, style: DebateCellStyle = .regular) {
        debateShortView.setup(debate, style: style)
    }

    func toggleFavorite() {
        debateShortView.debateBottomContainer.debateInfoView.toggleFavorite()
    }

}
