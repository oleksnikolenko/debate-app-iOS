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

typealias CreationHandler = (Debate, UIViewController) -> ()

protocol CreateDebateDisplayLogic: class {
    func didCreateDebate(_ debate: Debate)
}

class CreateDebateViewController: UIViewController, CreateDebateDisplayLogic {

    // MARK: - Subviews
    private lazy var leftSidePhoto = UIImageView().with {
        $0.image = placeholderImage
        $0.contentMode = .scaleAspectFill
        $0.isUserInteractionEnabled = true
        $0.layer.masksToBounds = true
    }
    private lazy var debateName = UITextView().with {
        $0.textAlignment = .center
        $0.delegate = self
        $0.text = "debate.name.placeholder".localized
        $0.textColor = .lightGray
        $0.font = .systemFont(ofSize: 18)
    }
    private lazy var leftSideName = UITextField().with {
        $0.borderStyle = .none
        $0.placeholder = "debate.left".localized
        $0.returnKeyType = .done
        $0.delegate = self
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
        $0.placeholder = "debate.right".localized
        $0.returnKeyType = .done
        $0.delegate = self
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
    private lazy var segmentedControl = UISegmentedControl().with {
        $0.backgroundColor = UIColor.white
        $0.selectedSegmentIndex = 0
    }

    // MARK: - Properties
    var interactor: CreateDebateBusinessLogic?
    var router: (NSObjectProtocol & CreateDebateRoutingLogic & CreateDebateDataPassing)?
    var creationHandler: CreationHandler?
    let disposeBag = DisposeBag()
    let dataPicker: DataPicker = DataPickerImplementation.shared
    let placeholderImage = UIImage(named: "debatePlaceholder")
    private var debateType: DebateType = .sides
    let debateNameHeightBounds: ClosedRange<CGFloat> = 40...120
    var debateNameHeight: CGFloat {
        debateName.sizeThatFits(
            CGSize(
                width: debateName.bounds.width,
                height: .infinity
            )
        ).height.inRange(of: debateNameHeightBounds)
    }

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
    convenience init(creationHandler: CreationHandler?) {
        self.init()
        self.creationHandler = creationHandler
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

        AnalyticsService.shared.trackScreen(.create)

        view.addSubviews(
            segmentedControl,
            leftSidePhoto,
            rightSidePhoto,
            debateName,
            leftSideName,
            rightSideName,
            createButton,
            categoryButton,
            middleSeparator
        )
        bindObservables()

        setupSegmentController(with: [.sides, .statement])
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        layout()
    }

    func bindObservables() {
        leftSidePhoto.didClick
            .subscribe(onNext: { [weak self] in
                guard let `self` = self else { return }
                self.view.endEditing(true)
                self.dataPicker.tryToFetchImage(vc: self) { [weak self] in
                    self?.leftImage = $0
                }
            }).disposed(by: disposeBag)

        rightSidePhoto.didClick
            .subscribe(onNext: { [weak self] in
                guard let `self` = self else { return }
                self.view.endEditing(true)
                self.dataPicker.tryToFetchImage(vc: self) { [weak self] in
                    self?.rightImage = $0
                }
            }).disposed(by: disposeBag)

        createButton.rx.tap
            .subscribe(onNext: { [weak self] in
                switch self?.debateType {
                case .sides:
                    self?.handleCreateSides()
                case .statement:
                    self?.handleCreateStatement()
                default:
                    break
                }
            }).disposed(by: disposeBag)

        categoryButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                let pickCategoryViewController = PickCategoryViewController { [weak self] in
                    self?.category = $0
                    self?.categoryButton.setTitle($0.name, for: .normal)
                    self?.categoryButton.setTitleColor(self?.leftSideName.textColor, for: .normal)
                }
                self.view.endEditing(true)
                self.present(pickCategoryViewController, animated: true, completion: nil)
            }).disposed(by: disposeBag)

        debateName.rx.text.subscribe(onNext: { _ in
            self.view.setNeedsLayout()
            }).disposed(by: disposeBag)

    }

    func layout() {
        segmentedControl.pin
            .top(8)
            .horizontally(24)
            .sizeToFit(.width)

        switch debateType {
        case .sides:
            leftSidePhoto.pin
                .start()
                .below(of: segmentedControl)
                .height(150)
                .width(50%)
                .marginTop(8)

            rightSidePhoto.pin
                .end()
                .below(of: segmentedControl)
                .height(150)
                .width(50%)
                .marginTop(8)
        case .statement:
            leftSidePhoto.pin
                .start()
                .below(of: segmentedControl)
                .height(225)
                .horizontally()
                .marginTop(8)
        }

        debateName.pin
            .horizontally(16)
            .height(debateNameHeight)
            .below(of: leftSidePhoto)
            .marginTop(16)

        leftSideName.pin
            .width(45%)
            .sizeToFit(.width)
            .start()
            .below(of: debateName)
            .marginStart(16)
            .marginTop(16)

        rightSideName.pin
            .width(45%)
            .sizeToFit(.width)
            .end()
            .below(of: debateName)
            .marginEnd(16)
            .marginTop(16)

        categoryButton.pin
            .horizontally(16)
            .sizeToFit(.width)
            .below(of: rightSideName)
            .marginTop(16)

        createButton.pin
            .horizontally(20)
            .height(48)
            .below(of: categoryButton)
            .marginTop(20)

        middleSeparator.pin
            .height(of: leftSidePhoto)
            .hCenter()
            .below(of: segmentedControl)
            .width(0.5)
            .marginTop(8)
    }

    func statementLayout() {
        segmentedControl.pin
            .top(8)
            .horizontally(24)
            .sizeToFit(.width)

        leftSidePhoto.pin
            .start()
            .below(of: segmentedControl)
            .height(225)
            .horizontally()
            .marginTop(8)
    }

    func notEnoughData(error: String) {
        let alert = UIAlertController(
            title: "alert.title".localized,
            message: String(format: "debate.somethingNotFilled".localized, error),
            preferredStyle: .alert
        )
        alert.addAction(.init(title: "okay".localized, style: .default, handler: nil))

        present(alert, animated: true, completion: nil)
    }

    func didCreateDebate(_ debate: Debate) {
        creationHandler?(debate, self)
    }

    private func setupDebateSidesType() {
        debateType = .sides

        debateName.text = debateType.debateNamePlaceholder
        debateName.textColor = UIColor.lightGray
        debateName.resignFirstResponder()

        leftSidePhoto.image = placeholderImage
        rightSidePhoto.image = placeholderImage

        leftSideName.text = nil
        rightSideName.text = nil

        rightSidePhoto.isHidden = false
        middleSeparator.isHidden = false

        view.setNeedsLayout()
    }

    private func setupDebateStatementType() {
        debateType = .statement

        debateName.text = debateType.debateNamePlaceholder
        debateName.textColor = UIColor.lightGray
        debateName.resignFirstResponder()

        leftSidePhoto.image = placeholderImage
        leftSideName.text = "yes".localized

        rightSideName.text = "no".localized
        rightSidePhoto.isHidden = true

        middleSeparator.isHidden = true

        view.setNeedsLayout()
    }

    private func handleCreateSides() {
        guard let leftImage = leftImage else {
            notEnoughData(error: "debate.leftImage".localized)
            return
        }

        guard let rightImage = rightImage else {
            notEnoughData(error: "debate.rightImage".localized)
            return
        }

        guard let leftName = leftSideName.text, !leftName.isEmpty else {
            notEnoughData(error: "debate.left".localized)
            return
        }

        guard let rightName = rightSideName.text, !rightName.isEmpty else {
            notEnoughData(error: "debate.right".localized)
            return
        }

        guard let categoryId = category?.id else {
            notEnoughData(error: "debate.category".localized)
            return
        }

        interactor?.createDebateSides(request: .init(
            leftName: leftName,
            rightName: rightName,
            leftImage: leftImage,
            rightImage: rightImage,
            categoryId: categoryId,
            name: debateName.text
        ))
    }

    private func handleCreateStatement() {
        guard let debateImage = leftImage else {
            notEnoughData(error: "debate.image".localized)
            return
        }

        guard let debateName = debateName.text, !debateName.isEmpty else {
            notEnoughData(error: "debate.name.placeholder.required".localized)
            return
        }

        guard let leftName = leftSideName.text, !leftName.isEmpty else {
            notEnoughData(error: "debate.left".localized)
            return
        }

        guard let rightName = rightSideName.text, !rightName.isEmpty else {
            notEnoughData(error: "debate.right".localized)
            return
        }

        guard let categoryId = category?.id else {
            notEnoughData(error: "debate.category".localized)
            return
        }

        interactor?.createDebateStatement(request: .init(
            leftName: leftName,
            rightName: rightName,
            debateImage: debateImage,
            categoryId: categoryId,
            name: debateName
            ))
    }

    private func setupSegmentController(with debateTypes: [DebateType]) {
        for index in 0..<debateTypes.count {
            segmentedControl.insertSegment(withTitle: debateTypes[index].name, at: index, animated: true)
        }
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
    }

    @objc func segmentedControlValueChanged() {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            setupDebateSidesType()
        case 1:
            setupDebateStatementType()
        default:
            break
        }
    }

}

// MARK: - Debate name delegate
extension CreateDebateViewController: UITextViewDelegate {

    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray {
            textView.text = nil
            textView.textColor = .black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = debateType.debateNamePlaceholder
            textView.textColor = UIColor.lightGray
        }
    }

}

extension CreateDebateViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }

}
