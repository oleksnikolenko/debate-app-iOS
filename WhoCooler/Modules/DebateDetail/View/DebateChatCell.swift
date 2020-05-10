//
//  DebateChatCell.swift
//  WhoCooler
//
//  Created by Artem Trubacheev on 11.04.2020.
//  Copyright © 2020 Artem Trubacheev. All rights reserved.
//

import RxSwift

class DebateChatCell: UITableViewCell {

    // MARK: - Subviews
    private lazy var avatar = UIImageView().with {
        $0.layer.masksToBounds = true
        $0.clipsToBounds = true
    }
    private let name = UILabel().with {
        $0.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
    }
    private let messageLabel = UILabel().with {
        $0.numberOfLines = 0
        $0.font = UIFont.systemFont(ofSize: 14, weight: .regular)
    }
    private let dateLabel = UILabel().with {
        $0.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        $0.textColor = .lightGray
    }
    private let replyButton = UIButton().with {
        $0.setTitleColor(.lightGray, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        // TODO: - Localize
        $0.setTitle("Reply", for: .normal)
    }
    private let voteButton = VoteMessageButton()
    private let showRepliesButton = UIButton().with {
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
    }
    private let moreButton = UIButton().with {
        $0.setImage(UIImage(named: "menu")?.withRenderingMode(.alwaysOriginal), for: .normal)
        $0.tintColor = .black
    }

    // MARK: - Properties
    var disposeBag = DisposeBag()
    var style: MessageStyle = .message {
        didSet {
            voteButton.style = style
        }
    }
    var model: Message?
    var showRepliesPressed: Observable<Void> {
        showRepliesButton.didClick.asObservable()
    }
    var replyPressed: Observable<String> {
        replyButton.rx.tap
            .map { [unowned self] in
                self.style == .message ? self.model?.id : self.model?.threadId
            }
            .skipNil()
    }
    var moreButtonClicked: Observable<Void> {
        moreButton.rx.tap.asObservable()
    }
    var authRequired: Observable<Void> {
        voteButton.isAuthRequired.asObservable()
    }
    var noInternet: Observable<Void> {
        voteButton.noInternet.asObservable()
    }

    private var hasNotShownReplies: Bool {
        guard let model = model else { return false }
        return model.notShownReplyCount > 0
    }

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        clipsToBounds = true
        selectionStyle = .none

        addSubviews(
            avatar,
            name,
            messageLabel,
            dateLabel,
            voteButton,
            replyButton,
            showRepliesButton,
            moreButton
        )
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Reuse
    override func prepareForReuse() {
        super.prepareForReuse()

        disposeBag = DisposeBag()
    }

    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()

        layout()
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        contentView.pin.width(size.width)
        layout()

        return CGSize(
            width: size.width,
            height: hasNotShownReplies
                ? showRepliesButton.frame.maxY + style.bottomMargin
                : voteButton.frame.maxY + style.bottomMargin
        )
    }

    private func layout() {
        avatar.pin
            .size(style.avatarSize)
            .start(style.startMargin)
            .top(style.topMargin)

        moreButton.pin
            .size(CGSize(width: 16, height: 16))
            .top(style.topMargin)
            .end(20)

        name.pin
            .after(of: avatar)
            .marginStart(12)
            .sizeToFit()
            .top(to: avatar.edge.top)
            .marginTop(4)

        dateLabel.pin
            .after(of: name)
            .marginStart(8)
            .bottom(to: name.edge.bottom)
            .sizeToFit()

        messageLabel.pin
            .below(of: name, aligned: .left)
            .marginTop(8)
            .end(20)
            .sizeToFit(.width)

        replyButton.pin
            .below(of: messageLabel, aligned: .left)
            .sizeToFit()
            .marginTop(4)

        voteButton.pin
            .height(18)
            .sizeToFit(.height)
            .end(20)
            .vCenter(to: replyButton.edge.vCenter)

        if hasNotShownReplies {
            showRepliesButton.pin
                .below(of: voteButton)
                .left(to: name.edge.left)
                .marginTop(8)
                .sizeToFit()
        }
    }

    func setup(_ message: Message) {
        self.model = message

        showRepliesButton.isHidden = !hasNotShownReplies
        avatar.kf.setImage(with: try? message.user.avatar.asURL())
        avatar.layer.cornerRadius = style.avatarSize.height / 2
        // TODO: - Localize
        showRepliesButton.setTitle("Show " + message.notShownReplyCount.description + " more replies", for: .normal)
        name.text = message.user.name
        messageLabel.text = message.text
        dateLabel.text = message.createdTime.toDate.dateSinceNow
        voteButton.model = message
    }

}

private extension MessageStyle {

    var startMargin: CGFloat {
        switch self {
        case .message:
            return 20
        case.reply:
            return 40
        }
    }

    var avatarSize: CGSize {
        switch self {
        case .message:
            return CGSize(width: 36, height: 36)
        case .reply:
            return CGSize(width: 24, height: 24)
        }
    }

    var topMargin: CGFloat {
        switch self {
        case .message:
            return 12
        case .reply:
            return 8
        }
    }

    var bottomMargin: CGFloat {
        switch self {
        case .message:
            return 12
        case .reply:
            return 0
        }
    }

}
