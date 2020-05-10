//
//  CategoryTableViewCell.swift
//  WhoCooler
//
//  Created by Alex Nikolenko on 03/05/2020.
//  Copyright © 2020 Artem Trubacheev. All rights reserved.
//

import RxCocoa
import RxSwift

class CategoryTableViewCell: UITableViewCell {

    // MARK: - Subviews
    private lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: collectionViewFlowLayout
    ).with {
        $0.delegate = self
        $0.dataSource = self
        $0.backgroundColor = .white
        $0.alwaysBounceHorizontal = true
        $0.showsHorizontalScrollIndicator = false
        $0.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
    }
    private var collectionViewFlowLayout = UICollectionViewFlowLayout().with {
        $0.scrollDirection = .horizontal
        $0.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
    }
    private lazy var sortingLabel = UILabel().with {
        $0.textColor = .lightGray
        $0.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        $0.text = selectedSorting.name
        $0.isUserInteractionEnabled = true
    }
    private let sortingIcon = UIImageView().with {
        $0.image = UIImage(named: "downarrow")
        $0.isUserInteractionEnabled = true
    }

    // MARK: - Properties
    var disposeBag = DisposeBag()
    var model: [Category]? {
        didSet {
            model?.insert(Category.favorites, at: 0)
            model?.insert(Category.all, at: 0)
            reloadCollectionView()
        }
    }
    var didClickSorting: Observable<Void> {
        return Observable.merge(sortingLabel.didClick, sortingIcon.didClick)
    }
    /// TODO: - Localize
    lazy var selectedCategory = BehaviorRelay<Category>(value: Category.all)
    var selectedSorting: DebateSorting = .popular {
        didSet {
            sortingLabel.text = selectedSorting.name
            setNeedsLayout()
        }
    }

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none
        addSubviews(collectionView, sortingLabel, sortingIcon)
        collectionView.contentInsetAdjustmentBehavior = .never
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Reuse
    override func prepareForReuse() {
        super.prepareForReuse()

        disposeBag = DisposeBag()
    }

    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()

        layout()
    }

    private func layout() {
        collectionView.pin
            .horizontally(12)
            .height(40)
            .top()

        sortingLabel.pin
            .below(of: collectionView)
            .start(12)
            .sizeToFit()
            .marginTop(4)

        sortingIcon.pin
            .after(of: sortingLabel)
            .marginStart(4)
            .size(10)
            .vCenter(to: sortingLabel.edge.vCenter)
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        pin.width(size.width)
        layout()
        return CGSize(width: size.width, height: sortingLabel.frame.maxY)
    }

    // MARK: - Private methods
    private func reloadCollectionView() {
        let contentOffset = collectionView.contentOffset
        collectionView.reloadData()
        layoutIfNeeded()
        collectionView.setContentOffset(contentOffset, animated: false)
    }

    func setSorting(sorting: DebateSorting) {
        selectedSorting = sorting
    }

}

extension CategoryTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        model?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.cell(at: indexPath, for: CategoryCollectionCell.self)
        if let category = model?[safe: indexPath.row] {
            cell.setup(category, isSelected: category.id == selectedCategory.value.id)
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let category = model?[safe: indexPath.row] {
            selectedCategory.accept(category)
        }
    }

}
