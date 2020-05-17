//
//  SearchViewController.swift
//  WhoCooler
//
//  Created by Alex Nikolenko on 04/05/2020.
//  Copyright © 2020 Artem Trubacheev. All rights reserved.
//

import ESPullToRefresh
import UIKit

protocol SearchDisplayLogic: class {
    func displayCells(viewModel: SearchModel.ViewModel)
}

class SearchViewController: UIViewController, SearchDisplayLogic {

    // MARK: - Subviews
    private lazy var tableView = UITableView().with {
        $0.dataSource = self
        $0.delegate = self
        $0.separatorStyle = .none
        $0.es.addInfiniteScrolling { [weak self] in
            self?.interactor?.getNextPage()
        }
    }
    private lazy var searchBar = UISearchBar().with {
        $0.placeholder = "search.placeholder".localized
        $0.barTintColor = .white
        $0.delegate = self
        $0.backgroundColor = .lightGray
        //$0.searchTextField.backgroundColor = UIColor.init(red: 243/255, green: 242/255, blue: 248/255, alpha: 1)
    }

    // MARK: - Properties
    var interactor: SearchBusinessLogic?
    var router: (NSObjectProtocol & SearchRoutingLogic)?

    var cells: [SearchModel.CellType] = [] {
        didSet {
            tableView.reloadData()
        }
    }

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
        let interactor = SearchInteractor()
        let presenter = SearchPresenter()
        let router = SearchRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.view = viewController
        router.viewController = viewController
    }

    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        edgesForExtendedLayout = []

        navigationController?.navigationBar.isTranslucent = false

        view.addSubviews(searchBar, tableView)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        tabBarController?.tabBar.isHidden = false
    }

    // MARK: - Layout
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        layout()
    }

    private func layout () {
        searchBar.pin
            .top()
            .horizontally()
            .sizeToFit(.width)

        tableView.pin
            .below(of: searchBar)
            .horizontally()
            .bottom()
    }

    // MARK: - Protocol methods
    func displayCells(viewModel: SearchModel.ViewModel) {
        self.cells = viewModel.cells

        tableView.es.stopLoadingMore()
        tableView.es.stopPullToRefresh()

        if viewModel.hasNextPage {
            tableView.es.resetNoMoreData()
        } else {
            tableView.es.noticeNoMoreData()
        }
    }

}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { cells.count }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch cells[indexPath.row] {
        case .debate(let debate):
            let cell = tableView.cell(for: DebateShortCell.self)
            cell.setup(debate, style: .search)
    
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch cells[indexPath.row] {
        case .debate(let debate):
            router?.navigateToDebate(debate)
        }
    }

}

extension SearchViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        /// Because we shouldn't send request with each character while typing
        NSObject.cancelPreviousPerformRequests(
            withTarget: self,
            selector: #selector(searchContext(_:)),
            object: searchBar
        )
        perform(#selector(searchContext(_:)), with: searchBar, afterDelay: 0.5)
    }

    @objc func searchContext(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text, searchText.count > 2 {
            interactor?.search(request: .init(searchContext: searchText, page: 1))
        }
    }

}
