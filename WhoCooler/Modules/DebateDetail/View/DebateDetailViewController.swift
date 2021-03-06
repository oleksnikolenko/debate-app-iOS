
//
//  DebateDetailViewController.swift
//  DebateMaker
//
//  Created by Artem Trubacheev on 09.04.2020.
//  Copyright (c) 2020 Artem Trubacheev. All rights reserved.
//

import PinLayout
import RxSwift

protocol DebateDetailDisplayLogic: class, MessageDisplayLogic {
    func displayDebate(viewModel: DebateDetail.Initializing.ViewModel)
    func setReachEnd(_ didReach: Bool)
    func updateVotes(_ debate: DebateDetail.Vote.ViewModel)
    func navigateToAuthorization()
    func showNoInternet()
}

class DebateDetailViewController: UIViewController, DebateDetailDisplayLogic {

    // MARK: Subviews
    let header = DebateDetailHeader(frame: .zero)
    lazy var tableView = UITableView().with {
        $0.dataSource = self
        $0.delegate = self
        $0.tableHeaderView = header
        $0.separatorStyle = .none
        $0.es.addInfiniteScrolling { [weak self] in
            self?.interactor?.getNextMessagesPage()
        }
        $0.keyboardDismissMode = .onDrag
    }
    lazy var inputTextView = InputTextView().with {
        $0.textView.delegate = self
    }

    // MARK: - Properties
    var interactor: DebateDetailBusinessLogic?
    var router: (NSObjectProtocol & DebateDetailRoutingLogic & DebateDetailDataPassing)?
    var debate: Debate
    let oneReplyBatchCount = 5
    private lazy var keyboardHeight: CGFloat = view.pin.safeArea.bottom
    private let disposeBag = DisposeBag()

    var sections = [DebateDetailSection]() {
        didSet { tableView.reloadData() }
    }

    // MARK: Object lifecycle
    init(debate: Debate) {
        self.debate = debate

        super.init(nibName: nil, bundle: nil)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented")
    }

    // MARK: Setup
    private func setup() {
        let viewController = self
        let interactor = DebateDetailInteractor()
        let presenter = DebateDetailPresenter()
        let router = DebateDetailRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }

    // MARK: View lifecycle
    override func viewDidLoad() {
        AnalyticsService.shared.trackScreen(.detail)

        super.viewDidLoad()
        sendDebate()

        view.backgroundColor = .white
        view.addSubviews(
            tableView,
            inputTextView
        )

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)

        bindObservables()
    }

    @objc func dismissKeyboard() {
        let _ = inputTextView.resignFirstResponder()
    }

    // MARK: - Binding
    private func bindObservables() {
        NotificationCenter.default.rx.keyboardInfo
            .subscribe(onNext: { [unowned self] (height, duration, curve) in
                self.animateKeyboard(height, duration, curve)
            }).disposed(by: disposeBag)

        inputTextView.textChange
            .subscribe(onNext: { [weak self] _ in
                self?.view.setNeedsLayout()
            }).disposed(by: disposeBag)

        inputTextView.sendTap
            .subscribe(onNext: { [weak self] text, threadId, editedMessage in
                guard !text.isEmpty else { return }
                self?.interactor?.handleSend(request: .init(text: text, threadId: threadId, editedMessage: editedMessage))
            }).disposed(by: disposeBag)

        Observable.merge(
            header.voteButton.leftName.didClick,
            header.voteButton.leftPercentLabel.didClick
        ).subscribe(onNext: { [unowned self] _ in
                self.tableView.es.resetNoMoreData()
                self.interactor?.vote(request: .init(sideId: self.debate.leftSide.id))
            }).disposed(by: disposeBag)

        Observable.merge(
            header.voteButton.rightName.didClick,
            header.voteButton.rightPercentLabel.didClick
        ).subscribe(onNext: { [unowned self] _ in
                self.tableView.es.resetNoMoreData()
                self.interactor?.vote(request: .init(sideId: self.debate.rightSide.id))
            }).disposed(by: disposeBag)
    }

    // MARK: - Layout
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        layout()
    }

    private func layout() {
        header.sizeToFit()

        inputTextView.pin
            .horizontally()
            .sizeToFit(.width)
            .bottom(keyboardHeight)

        tableView.pin
            .top()
            .horizontally()
            .above(of: inputTextView)
    }

    private func animateKeyboard(_ height: CGFloat, _ duration: Double, _ curve: UInt) {
        keyboardHeight = max(height, view.pin.safeArea.bottom)
        UIView.animate(
            withDuration: duration,
            delay: 0,
            options: UIView.AnimationOptions(rawValue: curve),
            animations: { [unowned self] in
                self.layout()
            },
            completion: nil
        )
    }

    // MARK: Do something
    func sendDebate() {
        interactor?.initDebate(request: .init(debate: debate))
    }

    func displayDebate(viewModel: DebateDetail.Initializing.ViewModel) {
        debate = viewModel.debate
        header.setup(debate: viewModel.debate)
        sections = viewModel.sections

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            self?.tableView.es.stopPullToRefresh()
            self?.tableView.es.stopLoadingMore()
        }

        view.setNeedsLayout()
    }

    func setReachEnd(_ didReach: Bool) {
        tableView.es.stopLoadingMore()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            didReach
                ? self?.tableView.es.noticeNoMoreData()
                : self?.tableView.es.resetNoMoreData()
        }
    }

    func updateVotes(_ viewModel: DebateDetail.Vote.ViewModel) {
        header.updateVotes(debate: viewModel.debate)
    }

    func setupReplyInputTextView(threadId: String, message: Message) {
        inputTextView.threadId = threadId
        inputTextView.textView.becomeFirstResponder()
        inputTextView.textView.text = message.user.name + ", "
    }

    private func setupEditInput(message: Message) {
        inputTextView.editedMessage = message
        inputTextView.threadId = message.threadId
        inputTextView.textView.becomeFirstResponder()
        inputTextView.textView.text = message.text
    }

    func showMessageActionSheet(_ message: Message) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        if interactor?.currentUser?.id == message.user.id {
            actionSheet.addAction(UIAlertAction(title: "debate.actionSheet.edit".localized, style: .default)
            { [weak self] _ in
                self?.setupEditInput(message: message)
            })
            actionSheet.addAction(UIAlertAction(title: "deleteAction".localized, style: .destructive)
            { [weak self] _ in
                self?.showDeleteMessageAlert(message)
            })
        } else {
            actionSheet.addAction(UIAlertAction(title: "debate.actionSheet.block".localized, style: .default, handler: nil))
            actionSheet.addAction(UIAlertAction(title: "debate.actionSheet.report".localized, style: .default, handler: nil))
        }

        actionSheet.addAction(UIAlertAction(title: "cancelAction".localized, style: .cancel, handler: nil))

        present(actionSheet, animated: true, completion: nil)
    }

    private func showDeleteMessageAlert(_ message: Message) {
        let alertController = UIAlertController(
            title: "deleteAction".localized,
            message: "debate.actionSheet.sure".localized,
            preferredStyle: .alert
        )

        alertController.addAction(UIAlertAction(title: "cancelAction".localized, style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "deleteAction".localized, style: .default) { [weak self] _ in
            if let threadId = message.threadId {
                self?.interactor?.deleteReply(request: .init(message: message, threadId: threadId))
            } else {
                self?.interactor?.deleteMessage(request: .init(message: message))
            }
        })

        present(alertController, animated: true, completion: nil)
    }

    func navigateToAuthorization() {
        router?.navigateToAuthorization()
    }

    func showNoInternet() {
        let alert = UIAlertController(
            title: "error.noInternet".localized,
            message: nil,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "okay".localized, style: .default, handler: nil))

        self.present(alert, animated: true)
    }

}

extension DebateDetailViewController: UITextViewDelegate {

    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.gray {
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }

}

extension DebateDetailViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int { sections.count }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { sections[section].rows.count }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch sections[indexPath.section].rows[indexPath.row] {
        case .message(let message):
            let cell = tableView.cell(for: DebateChatCell.self)

            cell.style = .message
            cell.setup(message)

            cell.replyPressed.subscribe(onNext: { [weak self] in
                self?.setupReplyInputTextView(threadId: $0, message: message)
            }).disposed(by: cell.disposeBag)

            cell.moreButtonClicked.subscribe(onNext: { [weak self] in
                self?.showMessageActionSheet(message)
            }).disposed(by: cell.disposeBag)

            cell.showRepliesPressed.subscribe(onNext: { [weak self] in
                self?.interactor?.getNextRepliesPage(request: .init(parentMessage: message, index: indexPath.section))
            }).disposed(by: cell.disposeBag)

            cell.authRequired.subscribe(onNext: { [weak self] in
                self?.navigateToAuthorization()
            }).disposed(by: cell.disposeBag)

            cell.noInternet.subscribe(onNext: { [weak self] in
                self?.showNoInternet()
            }).disposed(by: cell.disposeBag)

            return cell

        case .reply(let reply):
            let cell = tableView.cell(for: DebateChatCell.self)

            cell.style = .reply
            cell.setup(reply)

            cell.moreButtonClicked.subscribe(onNext: { [weak self] in
                self?.showMessageActionSheet(reply)
            }).disposed(by: cell.disposeBag)

            cell.replyPressed.subscribe(onNext: { [weak self] in
                self?.setupReplyInputTextView(threadId: $0, message: reply)
            }).disposed(by: cell.disposeBag)

            cell.authRequired.subscribe(onNext: { [weak self] in
                self?.navigateToAuthorization()
            }).disposed(by: cell.disposeBag)

            cell.noInternet.subscribe(onNext: { [weak self] in
                self?.showNoInternet()
            }).disposed(by: cell.disposeBag)

            return cell

        case .emptyMessages:
            let cell = tableView.cell(for: EmptyDataCell.self)
            cell.style = .message
            return cell
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch sections[indexPath.section].rows[indexPath.row] {
        case .emptyMessages:
            return tableView.contentSize.height
        default:
            return UITableView.automaticDimension
        }
    }

}
