//
//  NavBarView.swift
//  WhoCooler
//
//  Created by Alex Nikolenko on 05.09.2020.
//  Copyright © 2020 Artem Trubacheev. All rights reserved.
//

import RxSwift
import UIKit

class NavBarView: UIView {

    // MARK: - Subviews
    private let titleLabel = UILabel().with {
        $0.font = .systemFont(ofSize: 16, weight: .semibold)
        $0.tintColor = .black
    }
    private let closeButton = UIButton().with {
        $0.tintColor = .gray
        $0.setImage(UIImage(named: "close"), for: .normal)
    }
    private let separator = UIView().with {
        $0.backgroundColor = UIColor(hex: 0xCACACA)
    }

    // MARK: - Properties
    var close: Observable<Void> { closeButton.rx.tap.asObservable() }

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubviews(closeButton, titleLabel, separator)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()

        layout()
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        pin.width(size.width)
        layout()

        return CGSize(width: frame.width, height: separator.frame.maxY + 8)
    }

    private func layout() {
        closeButton.pin
            .size(CGSize(width: 64, height: 24))
            .vCenter()
            .end()

        titleLabel.pin
            .center()
            .sizeToFit()

        separator.pin
            .height(0.5)
            .horizontally()
            .bottom()
    }

    // MARK: - Public methods
    func setup(title: String, isSeparatorHidden: Bool = false) {
        titleLabel.text = title
        separator.isHidden = isSeparatorHidden
    }

}
