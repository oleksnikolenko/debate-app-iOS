//
//  UserProfileMenuCell.swift
//  WhoCooler
//
//  Created by Alex Nikolenko on 22.07.2020.
//  Copyright © 2020 Artem Trubacheev. All rights reserved.
//

import UIKit

class UserProfileMenuCell: UITableViewCell {

    // MARK - Subviews
    private let itemImage = UIImageView()
    private let descriptionLabel = UILabel().with {
        $0.font = UIFont.systemFont(ofSize: 14, weight: .regular)
    }

    // MARK: - Properties
    private var imageMarginStart: CGFloat = 20
    private var descriptionMarginStart: CGFloat = 20

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        addSubviews(itemImage, descriptionLabel)

        selectionStyle = .none
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
        itemImage.pin
            .size(24)
            .vCenter()
            .start(imageMarginStart)

        descriptionLabel.pin
            .after(of: itemImage)
            .marginStart(descriptionMarginStart)
            .end(16)
            .sizeToFit(.width)
            .vCenter()
    }

    func setup(
        image: UIImage?,
        text: String,
        textColor: UIColor? = .black,
        imageMarginStart: CGFloat = 20,
        descriptionMarginStart: CGFloat = 20
    ) {
        self.itemImage.image = image
        self.descriptionLabel.text = text
        self.descriptionLabel.textColor = textColor
        self.imageMarginStart = imageMarginStart
        self.descriptionMarginStart = descriptionMarginStart

        setNeedsLayout()
    }

}

