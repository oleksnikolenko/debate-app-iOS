//
//  CategoryCollectionCell.swift
//  WhoCooler
//
//  Created by Alex Nikolenko on 03/05/2020.
//  Copyright © 2020 Artem Trubacheev. All rights reserved.
//

import UIKit

class CategoryCollectionCell: UICollectionViewCell {

    // MARK: - Subviews
    let label = UILabel().with {
        $0.font = UIFont.systemFont(ofSize: 16, weight: .regular)
    }

    // MARK: - Properties
    override var isSelected: Bool {
        didSet {
            label.textColor = isSelected ? .white : .black
            contentView.backgroundColor = isSelected ? .black : .white
        }
    }

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.layer.cornerRadius = 10
        contentView.layer.borderWidth = 0.5
        contentView.layer.borderColor = UIColor.gray.cgColor
        contentView.addSubview(label)
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
        layout()
        return CGSize(width: label.frame.width + 16, height: 30)
    }

    private func layout() {
        label.pin
            .sizeToFit()
            .center()
    }

    // MARK: - Public methods
    func setup(_ category: Category, isSelected: Bool) {
        label.text = category.name
        self.isSelected = isSelected

        setNeedsLayout()
    }

}
