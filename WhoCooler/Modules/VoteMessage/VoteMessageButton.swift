//
//  VoteMessageButton.swift
//  WhoCooler
//
//  Created by Alex Nikolenko on 30/04/2020.
//  Copyright © 2020 Artem Trubacheev. All rights reserved.
//

import RxSwift

protocol VoteMessageDisplayLogic: class {
    func update(model: Votable)
    func authRequired()
    func showNoInternet()
}

class VoteMessageButton: UIView {

    // MARK: - Subviews 
    private lazy var upImage = UIImageView().with {
        $0.tintColor = .darkGray
    }
    private lazy var downImage = UIImageView().with {
        $0.tintColor = .darkGray
    }
    private let upButton = UIButton()
    private let downButton = UIButton()
    private var voteCounter = UILabel().with {
        $0.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        $0.textColor = UIColor.black
    }
    private let chosenLikeImage = UIImage(named: "thumbup")?.withRenderingMode(.alwaysTemplate)
    private let notChosenLikeImage = UIImage(named: "notchosenlike")
    private let chosenDislikeImage = UIImage(named: "thumbdown")?.withRenderingMode(.alwaysTemplate)
    private let notChosenDislikeImage = UIImage(named: "notchosendislike")

    // MARK: - Properties
    private let disposeBag = DisposeBag()
    var interactor: VoteMessageInteractor?

    var style: MessageStyle = .message
    var isAuthRequired = PublishSubject<Void>()
    var noInternet = PublishSubject<Void>()
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
        addSubviews(upImage, downImage, voteCounter, upButton, downButton)
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
        upImage.pin
            .size(16)
            .top()
            .start()

        voteCounter.pin
            .sizeToFit()
            .after(of: upImage)
            .marginStart(12)
            .bottom(to: upImage.edge.bottom)

        downImage.pin
            .size(16)
            .after(of: voteCounter)
            .vCenter(to: upImage.edge.bottom)
            .marginTop(-4)
            .marginStart(12)

        upButton.pin
            .size(32)
            .center(to: upImage.anchor.center)

        downButton.pin
            .size(32)
            .center(to: downImage.anchor.center)
    }

    // MARK: - Private methods
    private func setup(_ model: Votable?) {
        guard let model = model else { return }

        voteCounter.text = model.votesCount.description
        if model.votesCount == 0 {
            voteCounter.textColor = UIColor.black.withAlphaComponent(0.85)
        } else if model.votesCount > 0 {
            voteCounter.textColor = UIColor.systemGreen.withAlphaComponent(0.85)
        } else if model.votesCount < 0 {
            voteCounter.textColor = UIColor.systemRed.withAlphaComponent(0.85)
        }

        switch model.voteType {
        case .up:
            upImage.image = chosenLikeImage
            downImage.image = notChosenDislikeImage
        case .down:
            downImage.image = chosenDislikeImage
            upImage.image = notChosenLikeImage
        case .none:
            upImage.image = notChosenLikeImage
            downImage.image = notChosenDislikeImage
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

    func authRequired() {
        isAuthRequired.onNext(())
    }

    func showNoInternet() {
        noInternet.onNext(())
    }

}
