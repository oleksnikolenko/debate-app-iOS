//
//  NewDebateCell.swift
//  WhoCooler
//
//  Created by Artem Trubacheev on 31.05.2020.
//  Copyright © 2020 Artem Trubacheev. All rights reserved.
//

import RxSwift

class NewDebateCell: TableViewCell {

    // MARK: - Subviews
    override var addableSubviews: [UIView] { [
        createButton
    ] }
    private let createButton = UIButton().with {
        $0.setTitle("debate.new".localized, for: .normal)
        $0.setTitleColor(.blue, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 14
        $0.layer.borderWidth = 0.5
        $0.layer.borderColor = UIColor.blue.cgColor
    }

    // MARK: - Properties
    var disposeBag = DisposeBag()
    var didClickCreate: Observable<Void> { createButton.rx.tap.asObservable() }

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

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
        layout()

        return .init(
            width: size.width,
            height: createButton.frame.maxY
        )
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        layout()
    }

    override func layout() {
        createButton.pin
            .top(16)
            .horizontally(16)
            .height(48)
    }

}
