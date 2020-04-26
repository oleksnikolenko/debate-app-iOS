//
//  DiscussionListViewController.swift
//  DiscussionMaker
//
//  Created by Artem Trubacheev on 18.01.2020.
//  Copyright (c) 2020 Artem Trubacheev. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import RxSwift
import ESPullToRefresh
import GoogleSignIn

protocol DiscussionListDisplayLogic: class {
    func displaySomething(viewModel: DiscussionList.Something.ViewModel)
}

class DiscussionListViewController: UIViewController, DiscussionListDisplayLogic {

    // MARK: - Subviews
    private lazy var tableView = UITableView().with {
        $0.dataSource = self
        $0.delegate = self
        $0.separatorStyle = .none
        $0.es.addPullToRefresh { [weak self] in
            self?.interactor?.getData(request: .init())
        }
        $0.es.addInfiniteScrolling { [weak self] in
            self?.interactor?.getNextPage()
        }
    }

    private lazy var profileButton = UIBarButtonItem(
        image: UIImage(named: "profile"),
        style: .plain,
        target: self,
        action: #selector(navigateToAuthorization)
    )

    // MARK: - Properties
    var cells: [DiscussionList.CellType] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    let disposeBag = DisposeBag()

    var interactor: DiscussionListBusinessLogic?
    var router: (NSObjectProtocol & DiscussionListRoutingLogic & DiscussionListDataPassing)?

    // MARK: Object lifecycle
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: - Setup
    private func setup() {
        let viewController = self
        let interactor = DiscussionListInteractor()
        let presenter = DiscussionListPresenter()
        let router = DiscussionListRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
    }

    // MARK: - Routing
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

        navigationController?.navigationBar.isTranslucent = false
        edgesForExtendedLayout = []

        title = "Debates"
        view.addSubviews(tableView)

        navigationItem.setRightBarButtonItems([profileButton], animated: true)

        let request = DiscussionList.Something.Request()
        interactor?.getData(request: request)
    }

    // MARK: - Layout
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        layout()
    }

    func layout () {
        tableView.pin.all()
    }

    // MARK: - Do something
    func displaySomething(viewModel: DiscussionList.Something.ViewModel) {
        self.cells = viewModel.cells

        tableView.es.stopLoadingMore()
        tableView.es.stopPullToRefresh()

        if viewModel.hasNextPage {
            tableView.es.resetNoMoreData()
        } else {
            tableView.es.noticeNoMoreData()
        }
    }

    @objc private func navigateToAuthorization() {
        router?.navigateToProfile()
    }

}

extension DiscussionListViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch cells[indexPath.row] {
        case .discussionLink(let discussion):
            let cell = tableView.cell(for: DiscussionShortCell.self)
            cell.setup(discussion)
            return cell
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { cells.count }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        switch cells[indexPath.row] {
        case .discussionLink(let discussion):
            router?.navigateToDebate(discussion)
        }
    }

}
