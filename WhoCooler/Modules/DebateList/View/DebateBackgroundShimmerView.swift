//
//  DebateBackgroundShimmerView.swift
//  WhoCooler
//
//  Created by Alex Nikolenko on 17/05/2020.
//  Copyright © 2020 Artem Trubacheev. All rights reserved.
//

import UIKit

class DebateBackgroundShimmerView: UIView {

    // MARK: - Subviews
    private var categoryCollection = ShimmerView()
    private var sortLabel = ShimmerView()
    private lazy var tableView = UITableView().with {
        $0.delegate = self
        $0.dataSource = self
    }

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubviews(categoryCollection, sortLabel, tableView)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()

        layout()
        categoryCollection.startAnimating(cornerRadius: 0)
        sortLabel.startAnimating(cornerRadius: 0)
    }

    private func layout() {
        categoryCollection.pin
            .height(40)
            .horizontally(12)
            .top(4)

        sortLabel.pin
            .below(of: categoryCollection)
            .width(80)
            .height(20)
            .start(12)
            .marginTop(8)

        tableView.pin
            .below(of: sortLabel)
            .horizontally()
            .bottom()
            .marginTop(2)
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        layout()
        return CGSize(width: size.width, height: tableView.frame.maxY)
    }

}

extension DebateBackgroundShimmerView: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 4 }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.cell(for: DebateShimmerCell.self)
    }

}

class DebateShimmerCell: UITableViewCell {

    // MARK: - Subviews
    private var sidesImage = ShimmerView()
    private var button = ShimmerView()
    private var separator = UIView().with {
        $0.backgroundColor = .lightGray
    }

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        addSubviews(sidesImage, button, separator)
        selectionStyle = .none
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()

        layout()
        sidesImage.startAnimating()
        button.startAnimating()
    }

    private func layout() {
        sidesImage.pin
            .height(150)
            .top(48)
            .horizontally(12)

        button.pin
            .horizontally(30)
            .below(of: sidesImage)
            .height(64)
            .marginTop(24)

        separator.pin
            .below(of: button)
            .marginTop(44)
            .horizontally()
            .height(2)
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        layout()
        return CGSize(width: size.width, height: separator.frame.maxY)
    }

}
