//
//  TableViewCell.swift
//  WhoCooler
//
//  Created by Artem Trubacheev on 26.01.2020.
//  Copyright © 2020 Artem Trubacheev. All rights reserved.
//

import UIKit
import PinLayout

class TableViewCell: UITableViewCell {

    var addableSubviews: [UIView] { [] }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        addSubviews(addableSubviews)
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
        contentView.pin.width(size.width)
        layout()

        return CGSize(width: size.width, height: addableSubviews.map { $0.frame.maxY }.max() ?? 0)
    }

    func layout() {
        // Method to override
    }

}
