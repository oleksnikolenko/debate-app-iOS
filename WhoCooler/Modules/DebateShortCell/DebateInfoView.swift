//
//  DebateInfoView.swift
//  DebateMaker
//
//  Created by Alex Nikolenko on 26/04/2020.
//  Copyright © 2020 Artem Trubacheev. All rights reserved.
//

import UIKit

class DebateInfoView: UIView {

    // MARK: - Views
    private let userImage = UIImageView().with {
        $0.image = UIImage(named: "user")
    }
    private let userCount = UILabel().with {
        $0.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
    }
    private let messageImage = UIImageView().with {
        $0.image = UIImage(named: "message")
    }
    private let messageCount = UILabel().with {
        $0.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
    }
    let favoritesImageView = UIImageView().with {
        $0.isUserInteractionEnabled = true
    }
    private let nonFilledFavoritesImage = UIImage(named: "nonFilledFavorites")
    private let filledFavoritesImage = UIImage(named: "filledFavorites")

    // MARK: - Properties
    var isFavorite: Bool = false

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubviews([
            userImage,
            userCount,
            messageImage,
            messageCount,
            favoritesImageView
        ])
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
        userImage.pin
            .size(18)
            .topStart()

        userCount.pin
            .after(of: userImage)
            .vCenter(to: userImage.edge.vCenter)
            .marginStart(10)
            .sizeToFit()

        messageImage.pin
            .size(18)
            .after(of: userCount)
            .marginStart(12)
            .top()

        messageCount.pin
            .after(of: messageImage)
            .vCenter(to: messageImage.edge.vCenter)
            .marginStart(10)
            .sizeToFit()

        favoritesImageView.pin
            .size(18)
            .after(of: messageCount)
            .vCenter(to: messageImage.edge.vCenter)
            .marginStart(12)
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        layout()

        return .init(
            width: favoritesImageView.frame.maxX,
            height: messageImage.frame.maxY
        )
    }

    // MARK: - Public methods
    func setup(_ debate: Debate) {
        userCount.text = debate.votesCount.description
        messageCount.text = debate.messageCount.description

        favoritesImageView.image = debate.isFavorite ? filledFavoritesImage : nonFilledFavoritesImage
        isFavorite = debate.isFavorite

        setNeedsLayout()
    }

    func toggleFavorite() {
        isFavorite = !isFavorite
        UIView.animate(
            withDuration: 0.15,
            animations: {
                self.favoritesImageView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }) { _ in
            UIView.animate(withDuration: 0.25, animations: {
                self.favoritesImageView.image = self.isFavorite
                    ? self.filledFavoritesImage
                    : self.nonFilledFavoritesImage
                self.favoritesImageView.transform = CGAffineTransform.identity
            })
        }
    }

}
