//
//  CollectionView.swift
//  SUHelpers
//
//  Created by Alex Nikolenko on 03/05/2020.
//  Copyright © 2020 Artem Trubacheev. All rights reserved.
//

import UIKit.UICollectionView

public extension UICollectionView {

    func cell<T: UICollectionViewCell>(at indexPath: IndexPath, for cellClass: T.Type) -> T {
        let reuseIdentifier = String(describing: cellClass)
        register(cellClass, forCellWithReuseIdentifier: reuseIdentifier)
        if let cell = dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? T {
            return cell
        }
        return cell(at: indexPath, for: cellClass)
    }

}
