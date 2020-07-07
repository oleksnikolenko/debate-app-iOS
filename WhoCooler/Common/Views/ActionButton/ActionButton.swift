//
//  ActionButton.swift
//  WhoCooler
//
//  Created by Artem Trubacheev on 30.06.2020.
//  Copyright © 2020 Artem Trubacheev. All rights reserved.
//

import Foundation
import RxSwift
import UIKit

class ActionButton: UIButton {

    // MARK: - Properties
    var didClickEdit: Observable<Void> {
        didClickEditButton.asObservable()
    }

    private let disposeBag = DisposeBag()
    private let didClickEditButton = PublishSubject<Void>()
    private var width: CGFloat = 56

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)

        clipsToBounds = false
        layer.masksToBounds = false

        backgroundColor = .white
        setImage(UIImage(named: "plus"), for: .normal)

        layer.cornerRadius = width / 2
        imageEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)

        layer.shadowOffset = CGSize(width: 1, height: 4)
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 4
        layer.shadowOpacity = 0.15

        bindObservables()

        accessibilityIdentifier = "ActionButton"
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layout
    override func sizeThatFits(_ size: CGSize) -> CGSize { CGSize(width: width, height: width) }

    private func bindObservables() {
        rx.tap.subscribe(onNext: { [unowned self] in
            self.didClickEditButton.onNext($0)
        }).disposed(by: disposeBag)
    }

}
