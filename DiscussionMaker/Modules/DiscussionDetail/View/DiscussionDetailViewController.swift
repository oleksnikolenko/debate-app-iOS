
//
//  DiscussionDetailViewController.swift
//  DiscussionMaker
//
//  Created by Artem Trubacheev on 09.04.2020.
//  Copyright (c) 2020 Artem Trubacheev. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import RxSwift
import PinLayout

protocol DiscussionDetailDisplayLogic: class {
    func displayDebate(viewModel: DiscussionDetail.Initializing.ViewModel)
    func setReachEnd(_ didReach: Bool)
    func didFinishSendMessage()
}

class DiscussionDetailViewController: UIViewController, DiscussionDetailDisplayLogic {

    var interactor: DiscussionDetailBusinessLogic?
    var router: (NSObjectProtocol & DiscussionDetailRoutingLogic & DiscussionDetailDataPassing)?
    var debate: Discussion
    var keyboardHeight: CGFloat = 0
    let disposeBag = DisposeBag()

    var sections = [DiscussionDetailSection]() {
        didSet {
            if oldValue.isEmpty {
                tableView.reloadData()
            } else {
                if #available(iOS 13, *) {
                    let diff = sections.difference(from: oldValue, by: {
                        $0.section == $1.section &&
                            $0.rows == $1.rows
                    })
                    var insertSections = [Int]()
                    var removeSections = [Int]()
                    
                    diff.forEach {
                        switch $0 {
                        case .insert(let offset, _, _):
                            insertSections.append(offset)
                        case .remove(let offset, _, _):
                            removeSections.append(offset)
                        }
                    }
                    tableView.beginUpdates()
                    tableView.deleteSections(IndexSet(removeSections), with: .bottom)
                    tableView.insertSections(IndexSet(insertSections), with: .top)
                    tableView.endUpdates()
                } else {
                    tableView.reloadData()
                }
            }
        }
    }

    // MARK: Subviews
    let header = DiscussionDetailHeader(frame: .zero)
    lazy var tableView = UITableView().with {
        $0.dataSource = self
        $0.delegate = self
        $0.tableHeaderView = header
        $0.es.addPullToRefresh { [weak self] in
            self?.interactor?.reloadDebate()
        }
        $0.es.addInfiniteScrolling { [weak self] in
            self?.interactor?.getNextMessagesPage()
        }
    }
    let inputTextView = InputTextView().with {
        $0.backgroundColor = .red
    }

    // MARK: Object lifecycle
    init(debate: Discussion) {
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
        let interactor = DiscussionDetailInteractor()
        let presenter = DiscussionDetailPresenter()
        let router = DiscussionDetailRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }

    // MARK: Routing
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }

    // MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        sendDebate()

        view.addSubviews(
            tableView,
            inputTextView
        )

        NotificationCenter.default.rx.keyboardInfo
            .subscribe(onNext: { [unowned self] (height, duration, curve) in
                self.animateKeyboard(height, duration, curve)
            }).disposed(by: disposeBag)

        inputTextView.textChange
            .subscribe(onNext: { [weak self] _ in
                self?.view.setNeedsLayout()
            }).disposed(by: disposeBag)

        inputTextView.sendTap
            .subscribe(onNext: { [weak self] in
                self?.interactor?.sendMessage(request: .init(message: $0))
            })

        header.leftSidePhoto.didClick
            .subscribe(onNext: { [unowned self] _ in
                self.tableView.es.resetNoMoreData()
                self.interactor?.vote(request: .init(sideId: self.debate.leftSide.id))
            }).disposed(by: disposeBag)

        header.rightSidePhoto.didClick
            .subscribe(onNext: { [unowned self] _ in
                self.tableView.es.resetNoMoreData()
                self.interactor?.vote(request: .init(sideId: self.debate.rightSide.id))
            }).disposed(by: disposeBag)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        layout()
    }

    private func layout() {
        header.sizeToFit()

        tableView.pin.all()
        inputTextView.pin
            .horizontally()
            .sizeToFit(.width)
            .bottom(self.keyboardHeight)
    }

    private func animateKeyboard(_ height: CGFloat, _ duration: Double, _ curve: UInt) {
        keyboardHeight = max(height, view.pin.safeArea.bottom)
        UIView.animate(
            withDuration: duration,
            delay: 0,
            options: UIView.AnimationOptions(rawValue: curve),
            animations: { [unowned self] in
                self.inputTextView.pin.bottom(self.keyboardHeight)
            },
            completion: nil
        )
    }

    // MARK: Do something
    func sendDebate() {
        interactor?.initDebate(request: .init(debate: debate))
    }

    func displayDebate(viewModel: DiscussionDetail.Initializing.ViewModel) {
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
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            didReach
                ? self?.tableView.es.noticeNoMoreData()
                : self?.tableView.es.resetNoMoreData()
        }
    }

    func didFinishSendMessage() {
        let _ = inputTextView.resignFirstResponder()
        inputTextView.emptyInput()
    }

}

extension DiscussionDetailViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections[section].rows.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch sections[indexPath.section].rows[indexPath.row] {
        case .message(let message):
            let cell = tableView.cell(for: DiscussionChatCell.self)

            cell.setup(message)

            return cell
        }
    }

}
