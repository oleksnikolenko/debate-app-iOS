//
//  CreateDebateViewController.swift
//  WhoCooler
//
//  Created by Artem Trubacheev on 31.05.2020.
//  Copyright (c) 2020 Artem Trubacheev. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import PinLayout
import RxSwift

protocol CreateDebateDisplayLogic: class {
    func displaySomething(viewModel: CreateDebate.Creation.ViewModel)
}

class CreateDebateViewController: UIViewController, CreateDebateDisplayLogic {

    // MARK: - Subviews
    private lazy var leftSidePhoto = UIImageView().with {
        $0.image = placeholderImage
        $0.contentMode = .scaleAspectFill
        $0.isUserInteractionEnabled = true
        $0.layer.masksToBounds = true
    }
    private lazy var leftSideName = UITextField().with {
        $0.borderStyle = .none
        $0.placeholder = "Left side"
        $0.textAlignment = .left
    }

    private lazy var rightSidePhoto = UIImageView().with {
        $0.image = placeholderImage
        $0.contentMode = .scaleAspectFill
        $0.isUserInteractionEnabled = true
        $0.layer.masksToBounds = true
    }
    private lazy var rightSideName = UITextField().with {
        $0.borderStyle = .none
        $0.placeholder = "Right side"
        $0.textAlignment = .right
    }
    private let categoryButton = UIButton().with {
        $0.setTitle("debate.categorySelect".localized, for: .normal)
        $0.setTitleColor(.gray, for: .normal)
        $0.contentHorizontalAlignment = .leading
    }
    private let createButton = UIButton().with {
        $0.setTitle("debate.new".localized, for: .normal)
        $0.setTitleColor(.blue, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 14
        $0.layer.borderWidth = 0.5
        $0.layer.borderColor = UIColor.blue.cgColor
    }
    private let middleSeparator = UIView().with {
        $0.backgroundColor = .lightGray
    }

    // MARK: - Properties
    var interactor: CreateDebateBusinessLogic?
    var router: (NSObjectProtocol & CreateDebateRoutingLogic & CreateDebateDataPassing)?
    let disposeBag = DisposeBag()
    let dataPicker: DataPicker = DataPickerImplementation.shared
    let placeholderImage = UIImage(named: "debatePlaceholder")

    var leftImage: UIImage? {
        didSet {
            leftSidePhoto.image = leftImage ?? placeholderImage
        }
    }
    var rightImage: UIImage? {
        didSet {
            rightSidePhoto.image = rightImage ?? placeholderImage
        }
    }

    var category: Category?

    // MARK: - Object lifecycle
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
        let interactor = CreateDebateInteractor()
        let presenter = CreateDebatePresenter()
        let router = CreateDebateRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }

    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        view.addSubviews(
            leftSidePhoto,
            rightSidePhoto,
            leftSideName,
            rightSideName,
            createButton,
            categoryButton,
            middleSeparator
        )
        bindObservables()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        layout()
    }

    func bindObservables() {
        leftSidePhoto.didClick
            .subscribe(onNext: { [weak self] in
                guard let `self` = self else { return }
                self.dataPicker.tryToFetchImage(vc: self) { [weak self] in
                    self?.leftImage = $0
                }
            }).disposed(by: disposeBag)

        rightSidePhoto.didClick
            .subscribe(onNext: { [weak self] in
                guard let `self` = self else { return }
                self.dataPicker.tryToFetchImage(vc: self) { [weak self] in
                    self?.rightImage = $0
                }
            }).disposed(by: disposeBag)

        createButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let `self` = self else { return }

                guard let leftName = self.leftSideName.text, !leftName.isEmpty else {
                    return
                }

                guard let rightName = self.rightSideName.text, !rightName.isEmpty else {
                    return
                }

                guard let leftImage = self.leftImage else {
                    return
                }

                guard let rightImage = self.rightImage else {
                    return
                }

                guard let categoryId = self.category?.id else {
                    return
                }

                self.interactor?.createDebate(request: .init(
                    leftName: leftName,
                    rightName: rightName,
                    leftImage: leftImage,
                    rightImage: rightImage,
                    categoryId: categoryId
                ))
            }).disposed(by: disposeBag)

        categoryButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                let pickCategoryViewController = PickCategoryViewController { [weak self] in
                    self?.category = $0
                    self?.categoryButton.setTitle($0.name, for: .normal)
                    self?.categoryButton.setTitleColor(self?.leftSideName.textColor, for: .normal)
                }
                self.present(pickCategoryViewController, animated: true, completion: nil)
            }).disposed(by: disposeBag)
    }

    func layout() {
        leftSidePhoto.pin
            .topStart()
            .height(150)
            .width(50%)

        rightSidePhoto.pin
            .topEnd()
            .height(150)
            .width(50%)

        leftSideName.pin
            .width(45%)
            .sizeToFit(.width)
            .start()
            .below(of: leftSidePhoto)
            .marginStart(16)
            .marginTop(8)

        rightSideName.pin
            .width(45%)
            .sizeToFit(.width)
            .end()
            .below(of: rightSidePhoto)
            .marginEnd(16)
            .marginTop(8)

        categoryButton.pin
            .horizontally(16)
            .sizeToFit(.width)
            .below(of: rightSideName)
            .marginTop(8)

        createButton.pin
            .horizontally(16)
            .height(48)
            .below(of: categoryButton)
            .marginTop(8)

        middleSeparator.pin
            .height(of: leftSidePhoto)
            .hCenter()
            .top()
            .width(0.5)
    }

    func displaySomething(viewModel: CreateDebate.Creation.ViewModel) {}

}