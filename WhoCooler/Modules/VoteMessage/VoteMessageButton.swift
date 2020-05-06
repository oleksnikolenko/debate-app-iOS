//
//  VoteMessageButton.swift
//  WhoCooler
//
//  Created by Alex Nikolenko on 30/04/2020.
//  Copyright © 2020 Artem Trubacheev. All rights reserved.
//

import RxSwift
import SUHelpers

protocol VoteMessageDisplayLogic: class {
    func update(model: Votable)
}

class VoteMessageButton: UIView {

    // MARK: - Subviews 
    private var upButton = UIButton().with {
        $0.setImage(UIImage(named: "thumbup")?.withRenderingMode(.alwaysTemplate), for: .normal)
        $0.tintColor = .lightGray
    }
    private var downButton = UIButton().with {
        $0.setImage(UIImage(named: "thumbdown")?.withRenderingMode(.alwaysTemplate), for: .normal)
        $0.tintColor = .lightGray
    }
    private var voteCounter = UILabel().with {
        $0.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        $0.textColor = UIColor.black
    }

    // MARK: - Properties
    private let disposeBag = DisposeBag()
    var interactor: VoteMessageInteractor?

    var style: MessageStyle = .message
    var model: Votable? {
        didSet {
            setup(model)
        }
    }

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)

        initialSetup()
        bindObservables()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Setup
    private func initialSetup() {
        let view = self
        let interactor = VoteMessageInteractor()
        let presenter = VoteMessagePresenter()
        view.interactor = interactor
        interactor.presenter = presenter
        presenter.view = view

        addSubviews(upButton, downButton, voteCounter)
    }

    // MARK: - Layout
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        layout()

        return CGSize(width: downButton.frame.maxX, height: downButton.frame.maxY)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        layout()
    }

    private func layout() {
        let buttonSize = CGSize(width: 18, height: 18)

        upButton.pin
            .size(buttonSize)
            .top()
            .start()

        voteCounter.pin
            .sizeToFit()
            .after(of: upButton)
            .marginStart(8)
            .vCenter(to: upButton.edge.vCenter)

        downButton.pin
            .size(buttonSize)
            .after(of: voteCounter)
            .top()
            .marginStart(8)
    }

    // MARK: - Private methods
    private func setup(_ model: Votable?) {
        guard let model = model else { return }

        voteCounter.text = model.votesCount.description

        switch model.voteType {
        case .up:
            upButton.tintColor = .blue
            downButton.tintColor = .gray
        case .down:
            upButton.tintColor = .gray
            downButton.tintColor = .blue
        case .none:
            upButton.tintColor = .gray
            downButton.tintColor = .gray
        }

        setNeedsLayout()
    }

    // MARK: - Binding
    private func bindObservables() {
        upButton.rx.tap.subscribe(onNext: { [weak self] in
            guard let `self` = self, let model = self.model else { return }

            if model.voteType == .up {
                self.interactor?.unvote(model, style: self.style)
            } else {
                self.interactor?.vote(model: model, voteType: .up, style: self.style)
            }
        }).disposed(by: disposeBag)

        downButton.rx.tap.subscribe(onNext: { [weak self] in
            guard let `self` = self, let model = self.model else { return }

            if model.voteType == .down {
                self.interactor?.unvote(model, style: self.style)
            } else {
                self.interactor?.vote(model: model, voteType: .down, style: self.style)
            }
        }).disposed(by: disposeBag)
    }

}

extension VoteMessageButton: VoteMessageDisplayLogic {

    func update(model: Votable) {
        self.model = model
    }

}
