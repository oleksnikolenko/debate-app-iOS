//
//  DebateListViewController.swift
//  WhoCooler
//
//  Created by Artem Trubacheev on 18.01.2020.
//  Copyright (c) 2020 Artem Trubacheev. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import ESPullToRefresh
import GoogleSignIn
import RxSwift
import RxCocoa

protocol DebateListDisplayLogic: class {
    func displayCells(viewModel: DebateList.Something.ViewModel)
    func reloadDebate(debateCell: DebateList.CellType)
    func navigateToAuthorization()
    func showNoInternet()
    func noticeNoMoreData()

    var selectedCategoryId: String? { get }
}

class DebateListViewController: UIViewController, DebateListDisplayLogic {

    // MARK: - Subviews
    private lazy var tableView = UITableView().with {
        $0.dataSource = self
        $0.delegate = self
        $0.separatorStyle = .none
        $0.es.addPullToRefresh { [weak self] in
            guard let `self` = self else { return }
            self.interactor?.getData(request: self.request)
        }
        $0.es.addInfiniteScrolling { [weak self] in
            self?.interactor?.getNextPage()
        }
    }
    private let addButton = ActionButton()

    var selectedCategoryId: String?
    private var selectedSorting: DebateSorting = .popular {
        didSet {
            guard selectedSorting != oldValue else { return }
            self.interactor?.getData(request: self.request)
        }
    }

    private lazy var profileButton = UIBarButtonItem(
        image: UIImage(named: "profile"),
        style: .plain,
        target: self,
        action: #selector(navigateToAuthorization)
    )

    private lazy var searchButton = UIBarButtonItem(
        barButtonSystemItem: .search,
        target: self,
        action: #selector(navigateToSearch)
    )

    private lazy var sortButton = UIBarButtonItem(
        image: UIImage(named: "sort"),
        style: .plain,
        target: self,
        action: #selector(didClickSortingIcon)
    ).with {
        $0.imageInsets = UIEdgeInsets(top: 0, left: 40, bottom: 0, right: 0)
    }

    // MARK: - Properties
    var request: DebateList.Something.Request {
        DebateList.Something.Request(categoryId: selectedCategoryId, selectedSorting: selectedSorting.rawValue)
    }
    var cells: [DebateList.CellType] = []
    var debateToReloadId: String?
    var indexPathToReload: IndexPath?

    let disposeBag = DisposeBag()

    var interactor: DebateListBusinessLogic?
    var router: (NSObjectProtocol & DebateListRoutingLogic & DebateListDataPassing)?

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
        let interactor = DebateListInteractor()
        let presenter = DebateListPresenter()
        let router = DebateListRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
    }

    // MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.isTranslucent = false
        edgesForExtendedLayout = []

        view.backgroundColor = .white
        tableView.backgroundView = DebateBackgroundShimmerView()

        title = "debates.screenName".localized
        view.addSubviews(tableView, addButton)

        navigationItem.leftBarButtonItem = profileButton
        navigationItem.rightBarButtonItems = [searchButton, sortButton]
        navigationController?.navigationBar.tintColor = .black

        addButton.didClickEdit
            .subscribe(onNext: { [weak self] in
                if UserDefaultsService.shared.session == nil {
                    self?.router?.navigateToProfile()
                } else {
                    self?.router?.navigateToNewDebate()
                }
            }).disposed(by: disposeBag)

        interactor?.getData(request: request)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        reloadDebateIfNeeded()
    }

    // MARK: - Layout
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        layout()
    }

    func layout () {
        tableView.pin.all()

        addButton.pin
            .sizeToFit()
            .bottomEnd(16)
    }

    // MARK: - Do something
    func displayCells(viewModel: DebateList.Something.ViewModel) {
        tableView.backgroundView = nil
        self.cells = viewModel.cells
        tableView.reloadData()

        tableView.es.stopLoadingMore()
        tableView.es.stopPullToRefresh()

        if viewModel.hasNextPage {
            tableView.es.resetNoMoreData()
        } else {
            tableView.es.noticeNoMoreData()
        }
    }

    func reloadDebate(debateCell: DebateList.CellType) {
        if let indexPath = indexPathToReload {
            tableView.updateWithoutAnimation {
                cells[indexPath.row] = debateCell
                tableView.reloadRows(at: [indexPath], with: .none)
            }

            debateToReloadId = nil
            indexPathToReload = nil
        }
    }

    private func reloadDebateIfNeeded() {
        if let debateToReloadId = debateToReloadId {
            interactor?.reloadDebate(debateId: debateToReloadId)
        }
    }

    @objc internal func navigateToAuthorization() {
        router?.navigateToProfile()
    }

    @objc private func navigateToSearch() {
        router?.navigateToSearch()
    }

    @objc private func didClickSortingIcon() {
        presentSortingActionSheet()
    }

    private func presentSortingActionSheet() {
        let actionSheet = UIAlertController(
            title: "debates.sort.title".localized,
            message: nil,
            preferredStyle: .actionSheet
        )

        actionSheet.addAction(UIAlertAction(title: "sorting.popular".localized, style: .default) { [weak self] _ in
            self?.selectedSorting = .popular
        })
        actionSheet.addAction(UIAlertAction(title: "sorting.newest".localized, style: .default) { [weak self] _ in
            self?.selectedSorting = .newest
        })
        actionSheet.addAction(UIAlertAction(title: "sorting.oldest".localized, style: .default) { [weak self] _ in
            self?.selectedSorting = .oldest
        })

        actionSheet.addAction(UIAlertAction(title: "cancelAction".localized, style: .cancel, handler: nil))

        present(actionSheet, animated: true)
    }

    func showNoInternet() {
        let alert = UIAlertController(
            title: "error.noInternet".localized,
            message: nil,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "error.tryAgain".localized, style: .default, handler: { [weak self] _ in
            guard let `self` = self else { return }

            if self.cells.isEmpty {
                self.interactor?.getData(request: self.request)
            }
        }))

        self.present(alert, animated: true)
    }

    func noticeNoMoreData() {
        tableView.es.noticeNoMoreData()
    }

}

extension DebateListViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch cells[indexPath.row] {
        case .debate(let debate):
            let cell = tableView.cell(for: DebateShortCell.self)

            cell.setup(debate)

            cell.didClickLeft.subscribe(onNext: { [weak self] in
                let completionHandler: ((Debate) -> Void)? = { debate in
                    cell.voteButton.setup(debate)
                }

                self?.interactor?.vote(
                    debateId: debate.id,
                    sideId: debate.leftSide.id,
                    successCompletion: completionHandler
                )
            }).disposed(by: cell.disposeBag)

            cell.didClickRight.subscribe(onNext: { [weak self] in
                let completionHandler: ((Debate) -> Void)? = { debate in
                    cell.voteButton.setup(debate)
                }
                self?.interactor?.vote(
                    debateId: debate.id,
                    sideId: debate.rightSide.id,
                    successCompletion: completionHandler
                )
            }).disposed(by: cell.disposeBag)

            cell.didClickFavorites
                .subscribe(onNext: { [weak self] in
                    guard let `self` = self else { return }

                    let completionHandler: (() -> Void)? = {
                        cell.toggleFavorite()
                    }
                    self.interactor?.toggleFavorites(
                        request: DebateList.Favorites.PostRequest(debate: debate, isFavorite: cell.debateInfoView.isFavorite),
                        successCompletion: completionHandler
                    )
                }).disposed(by: cell.disposeBag)

            cell.didClickMoreButton
                .subscribe(onNext: { [weak self] in
                    self?.showDebateActionSheet(debate: debate)
                }).disposed(by: cell.disposeBag)

            return cell

        case .categoryList(let categories):
            let cell = tableView.cell(for: CategoryTableViewCell.self)
            cell.model = categories

            cell.selectedCategory
                .skip(1)
                .distinctUntilChanged()
                .subscribe(onNext: { category in
                    self.selectedCategoryId = category.id
                    self.interactor?.getData(request: self.request)
                }).disposed(by: cell.disposeBag)

            return cell

        case .emptyFavorites:
            let cell = tableView.cell(for: EmptyDataCell.self)
            cell.style = .favorites
            return cell

        case .new:
            let cell = tableView.cell(for: NewDebateCell.self)

            cell.didClickCreate.subscribe(onNext: { [unowned self] in
                if UserDefaultsService.shared.session == nil {
                    self.router?.navigateToProfile()
                } else {
                    self.router?.navigateToNewDebate()
                }
            }).disposed(by: cell.disposeBag)

            return cell
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch cells[indexPath.row] {
        case .emptyFavorites:
            return tableView.frame.height
        default:
            return UITableView.automaticDimension
        }
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        switch cells[indexPath.row] {
        case .emptyFavorites:
            return tableView.frame.height
        default:
            return 335
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { cells.count }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        switch cells[indexPath.row] {
        case .debate(let debate):
            indexPathToReload = indexPath
            debateToReloadId = debate.id
            router?.navigateToDebate(debate)
        default:
            break
        }
    }

    func showDebateActionSheet(debate: Debate) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        actionSheet.addAction(UIAlertAction(title: "debate.actionSheet.block".localized, style: .default, handler: { [weak self] _ in
            self?.interactor?.reportDebate(id: debate.id)
        }))
        actionSheet.addAction(UIAlertAction(title: "debate.actionSheet.report".localized, style: .default, handler: { [weak self] _ in
            self?.interactor?.reportDebate(id: debate.id)
        }))
        actionSheet.addAction(UIAlertAction(title: "cancelAction".localized, style: .cancel, handler: nil))

        present(actionSheet, animated: true, completion: nil)
    }

}
