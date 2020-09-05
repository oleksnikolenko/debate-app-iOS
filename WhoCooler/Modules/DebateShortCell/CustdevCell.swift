//
//  CustdevCell.swift
//  WhoCooler
//
//  Created by Artem Trubacheev on 02.09.2020.
//  Copyright © 2020 Artem Trubacheev. All rights reserved.
//

import UIKit
import RxSwift

class CustdevCell: TableViewCell {

    // MARK: - Subviews
    override var addableSubviews: [UIView] { [
        custdevView
    ] }
    let custdevView = CustdevView()

    // MARK: - Properties
    var didClickAgree: Observable<Void> { custdevView.didClickAgree }
    var didClickClose: Observable<Void> { custdevView.didClickClose }
    var disposeBag = DisposeBag()
    var textChange: Observable<String?> {
        custdevView.textView.rx.text.changed.asObservable()
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
            height: custdevView.frame.maxY
        )
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        layout()
    }

    override func layout() {
        custdevView.pin
            .top(20)
            .horizontally(12)
            .sizeToFit(.width)
    }

}
