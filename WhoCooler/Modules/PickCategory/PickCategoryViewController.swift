//
//  PickCategoryViewController.swift
//  WhoCooler
//
//  Created by Artem Trubacheev on 06.06.2020.
//  Copyright (c) 2020 Artem Trubacheev. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import RxCocoa
import RxSwift

typealias SelectionHandler = (Category) -> ()
protocol PickCategoryDisplayLogic: class {
    func displayCategories(viewModel: PickCategory.GetCategories.ViewModel)
    func didSelectCategory(_ category: Category)
}

class PickCategoryViewController: UIViewController, PickCategoryDisplayLogic {

    var interactor: PickCategoryBusinessLogic?
    var router: (NSObjectProtocol & PickCategoryRoutingLogic & PickCategoryDataPassing)?
    var selectionHandler: SelectionHandler?
    private let disposeBag = DisposeBag()

    // MARK: - Subviews
    private lazy var searchBar = UISearchBar().with {
        $0.placeholder = "search.placeholder".localized
        $0.barTintColor = .white
        $0.delegate = self
        $0.backgroundColor = .lightGray
    }
    private lazy var addButton = UIButton().with {
        $0.setImage(UIImage(named: "plus")?.withRenderingMode(.alwaysTemplate), for: .normal)
        $0.imageView?.tintColor = UIColor.systemBlue
    }
    private lazy var tableView = UITableView().with {
        $0.delegate = self
        $0.dataSource = self
    }

    // MARK: - Properties
    var categories: [Category] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    // MARK: - Object lifecycle
    convenience init(selectionHandler: SelectionHandler?) {
        self.init()
        self.selectionHandler = selectionHandler
    }

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
        let interactor = PickCategoryInteractor()
        let presenter = PickCategoryPresenter()
        let router = PickCategoryRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
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

    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        interactor?.requestCategoryList()
        view.addSubviews(addButton, searchBar, tableView)

        bindObservables()
    }

    // MARK: - Binding
    private func bindObservables() {
        addButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.showCreateCategoryPopup()
        }).disposed(by: disposeBag)
    }

    // MARK: - Layout
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        searchBar.pin
            .top()
            .start(32)
            .end()
            .sizeToFit(.width)

        addButton.pin
            .start(12)
            .vCenter(to: searchBar.edge.vCenter)
            .size(16)

        tableView.pin
            .below(of: searchBar)
            .bottom()
            .horizontally()
    }

    private func showCreateCategoryPopup() {
        var textField: UITextField?
        let alert = UIAlertController(title: "alert.title".localized, message: nil, preferredStyle: .alert)

        // TODO - Localize
        alert.title = "category.createNew".localized
        alert.addTextField {
            textField = $0
            $0.placeholder = "category.name.placeholder".localized
        }

        alert.addAction(.init(title: "profile.alert.save".localized, style: .default, handler: { [weak self] _ in
            guard let textFieldText = textField?.text else { return }
            self?.interactor?.createCategory(request: .init(name: textFieldText))
        }))
        alert.addAction(.init(title: "cancelAction".localized, style: .cancel, handler: nil))

        present(alert, animated: true, completion: nil)
    }

    func displayCategories(viewModel: PickCategory.GetCategories.ViewModel) {
        self.categories = viewModel.categories
    }

    func didSelectCategory(_ category: Category) {
        selectionHandler?(category)

        self.dismiss(animated: true, completion: nil)
    }

}

extension PickCategoryViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categories.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.cell(for: UITableViewCell.self)
        cell.textLabel?.text = categories[indexPath.row].name

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectCategory(categories[indexPath.row])
    }

}

extension PickCategoryViewController: UISearchBarDelegate {

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
        if let searchText = searchBar.text {
            interactor?.searchCategory(request: .init(searchContext: searchText))
        }
    }

}

