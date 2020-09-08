//
//  RateAppView.swift
//  WhoCooler
//
//  Created by Alex Nikolenko on 08.09.2020.
//  Copyright © 2020 Artem Trubacheev. All rights reserved.
//

import RxSwift

class RateAppView: UIView {

    // MARK: - Subviews
    private let titleLabel = UILabel().with {
        $0.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        $0.textAlignment = .center
        $0.adjustsFontSizeToFitWidth = true
    }
    private let agreeButton = UIButton().with {
        $0.layer.cornerRadius = 10
        $0.backgroundColor = .blue
        $0.titleLabel?.font = .boldSystemFont(ofSize: 15)
        $0.setTitleColor(.white, for: .normal)
    }
    private let disagreeButton = UIButton().with {
        $0.layer.cornerRadius = 10
        $0.backgroundColor = .blue
        $0.titleLabel?.font = .boldSystemFont(ofSize: 15)
        $0.setTitleColor(.white, for: .normal)
    }

    // MARK: - Properties
    var state: RateAppCellState = .initialState
    var didAgreeToRateApp = PublishSubject<Void>()
    var didAskToClose: Observable<Void> {
        return disagreeButton.didClick.asObservable()
    }
    var disposeBag = DisposeBag()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubviews(titleLabel, agreeButton, disagreeButton)
        state = RateAppCellState(state: UserDefaultsService.shared.rateAppState)

        titleLabel.text = state.title
        agreeButton.setTitle(state.agreeButtonText, for: .normal)
        disagreeButton.setTitle(state.disagreeButtonText, for: .normal)

        setupViewStyle()
        bindObservables()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func bindObservables() {
        agreeButton.didClick.subscribe(onNext: {
            switch self.state {
            case .initialState:
                self.state = .likeChosen

                self.titleLabel.text = self.state.title
                self.agreeButton.setTitle(self.state.agreeButtonText, for: .normal)
                self.disagreeButton.setTitle(self.state.disagreeButtonText, for: .normal)

                self.setNeedsLayout()
            case .likeChosen:
                self.didAgreeToRateApp.onNext(())
            }
        }).disposed(by: disposeBag)
    }

    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()

        layout()
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        pin.width(size.width)
        layout()

        return CGSize(width: size.width, height: disagreeButton.frame.maxY + 20)
    }

    func layout() {
        titleLabel.pin
            .top(20)
            .horizontally(12)
            .sizeToFit(.width)

        agreeButton.pin
            .width(frame.width / 2.5)
            .end(frame.width / 15)
            .height(44)
            .below(of: titleLabel)
            .marginTop(20)

        disagreeButton.pin
            .width(frame.width / 2.5)
            .start(frame.width / 15)
            .height(44)
            .below(of: titleLabel)
            .marginTop(20)
    }

    private func setupViewStyle() {
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize(width: 1, height: 1)
        layer.shadowOpacity = 1
        layer.shadowRadius = 4
        layer.masksToBounds = false
        layer.cornerRadius = 10
        backgroundColor = .white
    }

}
