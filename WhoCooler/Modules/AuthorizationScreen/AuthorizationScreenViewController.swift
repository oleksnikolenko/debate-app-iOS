//
//  AuthorizationScreenViewController.swift
//  WhoCooler
//
//  Created by Artem Trubacheev on 04.04.2020.
//  Copyright (c) 2020 Artem Trubacheev. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import RxSwift

protocol AuthorizationScreenDisplayLogic: class {
    func displayProviders(viewModel: AuthorizationScreen.Providers.ViewModel)
    func didEndAuth(viewModel: AuthorizationScreen.Authorization.ViewModel)
}

class AuthorizationScreenViewController: UIViewController, AuthorizationScreenDisplayLogic {

    // MARK: - Subviews
    var authProviderButtons: [AuthButton] = [] {
        didSet {
            oldValue.forEach { $0.removeFromSuperview() }
            view.addSubviews(authProviderButtons)
            view.setNeedsLayout()
        }
    }
    private var informationLabel = UILabel().with {
        $0.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        $0.textColor = UIColor.black
        $0.numberOfLines = 0
        $0.textAlignment = .center
        // TODO: - Localize
        $0.text = "Please log in to vote and comment on Whocooler"
    }

    // MARK: - Properties
    var interactor: AuthorizationScreenBusinessLogic?
    var router: (NSObjectProtocol & AuthorizationScreenRoutingLogic & AuthorizationScreenDataPassing)?

    let disposeBag = DisposeBag()

    var authProviders: [AuthProvider] = [] {
        didSet {
            authProviderButtons = authProviders.map {
                .init(provider: $0)
            }
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

    // MARK: Setup
    private func setup() {
        let viewController = self
        let interactor = AuthorizationScreenInteractor()
        let presenter = AuthorizationScreenPresenter()
        let router = AuthorizationScreenRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }

    // MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        addSubviews()
        interactor?.getProviders(request: .init())
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        layout()
    }

    func layout() {
        let buttonSize = CGSize(width: 250, height: 44)
        var lastEdge = view.edge.vCenter

        informationLabel.pin
            .horizontally(view.frame.width / 6)
            .bottom(to: view.edge.vCenter)
            .sizeToFit(.width)
            .marginBottom(64)

        authProviderButtons.forEach {
            $0.pin
                .size(buttonSize)
                .top(to: lastEdge)
                .hCenter()
                .marginTop(8)

            lastEdge = $0.edge.bottom
        }
    }

    // MARK: - Private methods
    private func addSubviews() {
        view.addSubviews(informationLabel)
    }

    func displayProviders(viewModel: AuthorizationScreen.Providers.ViewModel) {
        authProviders = viewModel.providers

        Observable.merge(
            authProviderButtons.map {
                $0.authProviderSelected
            }
        ).subscribe(onNext: { [unowned self] in
            self.interactor?.didSelectProvider(request: .init(provider: $0))
        }).disposed(by: disposeBag)
    }

    func didEndAuth(viewModel: AuthorizationScreen.Authorization.ViewModel) {
        dismiss(animated: true, completion: nil)
    }

}