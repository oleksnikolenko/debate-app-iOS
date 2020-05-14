//
//  UserProfileViewController.swift
//  WhoCooler
//
//  Created by Artem Trubacheev on 24.04.2020.
//  Copyright (c) 2020 Artem Trubacheev. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import PinLayout
import RxSwift
//import SwiftMessages

protocol UserProfileDisplayLogic: class {
    func displayProfile(viewModel: UserProfile.Profile.ViewModel)
    func dismiss()
}

class UserProfileViewController: UIViewController, UserProfileDisplayLogic {

    // MARK: - Subviews
    lazy var avatar = UIImageView().with {
        $0.layer.cornerRadius = avatarSize.height / 2
        $0.layer.masksToBounds = true
        $0.clipsToBounds = true
        $0.isUserInteractionEnabled = true
    }
    let changeAvatarButton = UIButton().with {
        $0.setTitle("profile.changeAvatar".localized, for: .normal)
        $0.setTitleColor(.systemBlue, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
    }
    let userNameLabel = UILabel().with {
        $0.textAlignment = .left
        $0.textColor = .black
        $0.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        $0.numberOfLines = 0
        $0.isUserInteractionEnabled = true
    }
    let namePlaceholder = UILabel().with {
        $0.textColor = .lightGray
        $0.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        $0.text = "profile.namePlaceholder".localized
    }
    let changeNameButton = UIButton().with {
        $0.setTitle("profile.changeNameButtonText".localized, for: .normal)
        $0.setTitleColor(.systemBlue, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
    }
    let privacyPolicyButton = UIButton().with {
        $0.setTitle("profile.privacyPolicy".localized, for: .normal)
        $0.setTitleColor(.systemBlue, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .regular)
    }
    let logoutButton = UIButton().with {
        $0.setTitle("profile.logout".localized, for: .normal)
        $0.setTitleColor(.systemRed, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
    }
//    let userIdLabel = UILabel().with {
//        $0.textAlignment = .center
//        $0.textColor = .black
//        $0.numberOfLines = 0
//        $0.isUserInteractionEnabled = true
//    }
//    let pushTokenLabel = UILabel().with {
//        $0.textAlignment = .center
//        $0.textColor = .black
//        $0.numberOfLines = 0
//        $0.isUserInteractionEnabled = true
//    }
//    let accessTokenLabel = UILabel().with {
//        $0.textAlignment = .center
//        $0.textColor = .black
//        $0.numberOfLines = 0
//        $0.isUserInteractionEnabled = true
//    }

    // MARK: - Properties
    var viewModel: UserProfile.Profile.ViewModel?
    let disposeBag = DisposeBag()

    var interactor: UserProfileBusinessLogic?
    var router: (NSObjectProtocol & UserProfileRoutingLogic & UserProfileDataPassing)?
    var dataPicker = DataPickerImplementation.shared
    private let avatarSize = CGSize(width: 72, height: 72)

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
        let interactor = UserProfileInteractor()
        let presenter = UserProfilePresenter()
        let router = UserProfileRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor

        view.addSubviews(
            avatar,
            userNameLabel,
            privacyPolicyButton,
            logoutButton,
//            userIdLabel,
//            pushTokenLabel,
//            accessTokenLabel,
            changeAvatarButton,
            namePlaceholder,
            changeNameButton
        )
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
        getProfile()
        bindObservables()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        layout()
    }

    func bindObservables() {
        Observable.merge(
            changeAvatarButton.didClick,
            avatar.didClick
        ).subscribe(onNext: { [weak self] in
            guard let `self` = self else { return }

            self.dataPicker.tryToFetchImage(vc: self) { [weak self] in
                self?.interactor?.modify(
                    request: .init(avatar: $0, name: nil)
                )
            }
        }).disposed(by: disposeBag)

        Observable.merge(
            changeNameButton.didClick,
            userNameLabel.didClick
        ).subscribe(onNext: { [weak self] in
            guard let `self` = self else { return }
            self.presentChangeNameAlertController()
        }).disposed(by: disposeBag)

        privacyPolicyButton.didClick.subscribe(onNext: {
            /// TODO: - Provide link for privacy policy
            guard let url = URL(string: "https://www.google.com") else { return }
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }).disposed(by: disposeBag)

        logoutButton.didClick.subscribe(onNext: { [weak self] in
            self?.presentLogOutAlert()
        }).disposed(by: disposeBag)
//        userIdLabel.didClick
//            .compactMap { [weak self] in self?.viewModel?.user.id }
//            .subscribe(onNext: { [weak self] in self?.copy(text: $0) })
//            .disposed(by: disposeBag)
//
//        pushTokenLabel.didClick
//            .compactMap { [weak self] in self?.viewModel?.pushToken }
//            .subscribe(onNext: { [weak self] in self?.copy(text: $0) })
//            .disposed(by: disposeBag)
//
//        accessTokenLabel.didClick
//            .compactMap { [weak self] in self?.viewModel?.accessToken }
//            .subscribe(onNext: { [weak self] in self?.copy(text: $0) })
//            .disposed(by: disposeBag)
    }

    func layout() {
        avatar.pin
            .size(avatarSize)
            .top(40)
            .hCenter()

        changeAvatarButton.pin
            .below(of: avatar)
            .sizeToFit()
            .hCenter()
            .marginTop(16)

        namePlaceholder.pin
            .below(of: changeAvatarButton)
            .marginTop(16)
            .horizontally(20)
            .sizeToFit(.width)

        userNameLabel.pin
            .horizontally(20)
            .sizeToFit(.width)
            .below(of: namePlaceholder)
            .marginTop(8)

        changeNameButton.pin
            .below(of: userNameLabel)
            .start(20)
            .sizeToFit()

        privacyPolicyButton.pin
            .below(of: changeNameButton)
            .start(20)
            .sizeToFit()

        logoutButton.pin
            .below(of: privacyPolicyButton)
            .start(20)
            .sizeToFit()

//        userIdLabel.pin
//            .horizontally(8)
//            .sizeToFit(.width)
//            .below(of: changeNameButton)
//            .marginTop(30)

//        pushTokenLabel.pin
//            .horizontally(8)
//            .sizeToFit(.width)
//            .below(of: userIdLabel)
//            .marginTop(8)
//
//        accessTokenLabel.pin
//            .horizontally(8)
//            .sizeToFit(.width)
//            .below(of: pushTokenLabel)
//            .marginTop(8)
//
    }

    // MARK: Do something
    func getProfile() {
        interactor?.getProfile(request: .init())
    }

//    func copy(text: String?) {
//        UIPasteboard.general.string = text
//        SwiftMessages.defaultConfig.presentationContext = .window(windowLevel: .statusBar)
//        SwiftMessages.show {
//            let card = MessageView.viewFromNib(layout: .cardView)
//
//            card.configureContent(body: "Copied: \(text ?? "nothing")")
//            card.button?.isHidden = true
//            card.titleLabel?.isHidden = true
//            card.configureTheme(.success)
//
//            return card
//        }
//    }

    func displayProfile(viewModel: UserProfile.Profile.ViewModel) {
        self.viewModel = viewModel

        avatar.kf.setImage(with: try? viewModel.user.avatar.asURL())

        userNameLabel.text = viewModel.user.name
//        userIdLabel.text = viewModel.user.id
//        pushTokenLabel.text = "push token: " + viewModel.pushToken
//        accessTokenLabel.text = "access token: " + viewModel.accessToken

        view.setNeedsLayout()
    }

    func dismiss() {
        router?.dismiss()
    }

    // MARK: - Private methods
    private func presentChangeNameAlertController() {
        var textField: UITextField?

        let alert = UIAlertController(title: "profile.alert.title".localized, message: nil, preferredStyle: .alert)
        alert.title = "profile.alert.changeNickname".localized
        alert.addTextField {
            textField = $0
            $0.placeholder = "profile.namePlaceholder".localized
            $0.text = self.userNameLabel.text
        }
        alert.addAction(.init(title: "profile.alert.save".localized, style: .default, handler: { [weak self] _ in
            self?.interactor?.modify(request: .init(avatar: nil, name: textField?.text))
        }))
        alert.addAction(.init(title: "cancelAction".localized, style: .cancel, handler: nil))

        present(alert, animated: true, completion: nil)
    }

    private func presentLogOutAlert() {
        let alertController = UIAlertController(
            title: "profile.alert.logout".localized,
            message: "debate.actionSheet.sure".localized,
            preferredStyle: .alert
        )
        alertController.addAction(UIAlertAction(title: "cancelAction".localized, style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "yes".localized, style: .default) { [weak self] _ in
            self?.interactor?.logout()
        })

        present(alertController, animated: true, completion: nil)
    }

}
