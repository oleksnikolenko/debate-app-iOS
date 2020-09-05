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
    private lazy var tableView = UITableView().with {
        $0.delegate = self
        $0.dataSource = self
    }

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubviews(tableView)
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
        tableView.pin
            .top()
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

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        addSubviews(sidesImage)
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
    }

    private func layout() {
        sidesImage.pin
            .height(380)
            .top(20)
            .horizontally(12)
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        layout()
        return CGSize(width: size.width, height: sidesImage.frame.maxY)
    }

}
