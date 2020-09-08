//
//  RateAppCell.swift
//  WhoCooler
//
//  Created by Alex Nikolenko on 07.09.2020.
//  Copyright © 2020 Artem Trubacheev. All rights reserved.
//

import RxSwift

class RateAppCell: TableViewCell {

    // MARK: - Subviews
    let rateAppView = RateAppView()

    // MARK: - Properties
    var disposeBag = DisposeBag()

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        addSubviews(rateAppView)

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
            height: rateAppView.frame.maxY
        )
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        layout()
    }

    override func layout() {
        rateAppView.pin
            .top(20)
            .horizontally(12)
            .sizeToFit(.width)
    }

}
