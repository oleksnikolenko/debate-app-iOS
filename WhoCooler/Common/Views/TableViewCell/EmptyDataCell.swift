//
//  EmptyDataCell.swift
//  WhoCooler
//
//  Created by Alex Nikolenko on 10/05/2020.
//  Copyright © 2020 Artem Trubacheev. All rights reserved.
//

import UIKit

public enum EmptyDataCellStyle {
    case message
    case favorites
}

class EmptyDataCell: UITableViewCell {

    // MARK: - Subviews
    let placeholderText = UILabel().with {
        $0.textColor = UIColor.darkText
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }

    // MARK: - Properties
    var style: EmptyDataCellStyle = .message {
        didSet {
            placeholderText.font = style.font
            placeholderText.text = style.placeholderText

            setNeedsLayout()
        }
    }

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        addSubview(placeholderText)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()

        placeholderText.pin
            .horizontally(frame.width / 7)
            .sizeToFit(.width)
            .vCenter(style.centerMargin)
    }

}

public extension EmptyDataCellStyle {

    var centerMargin: CGFloat {
        switch self {
        case .message:
            return 0
        case .favorites:
            return -105
        }
    }

    var font: UIFont {
        switch self {
        case .favorites:
            return UIFont.systemFont(ofSize: 24, weight: .regular)
        case .message:
            return UIFont.systemFont(ofSize: 16, weight: .regular)
        }
    }

    var placeholderText: String {
        switch self {
        case .message:
            return "emptyData.messages".localized
        case .favorites:
            return "emptyData.favorites".localized
        }
    }

}
