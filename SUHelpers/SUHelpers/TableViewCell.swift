//
//  TableViewCell.swift
//  SUHelpers
//
//  Created by Artem Trubacheev on 26.01.2020.
//  Copyright © 2020 Artem Trubacheev. All rights reserved.
//

import UIKit.UITableView

public extension UITableView {

    /// Get cell of given class for indexPath
    ///
    /// - parameter indexPath: the indexPath
    /// - parameter cellClass: a cell class
    ///
    /// - returns: a reusable cell
    func cell<T: UITableViewCell>(for cellClass: T.Type) -> T {
        let reuseIdentifier = String(describing: cellClass)

        if let cell = self.dequeueReusableCell(withIdentifier: reuseIdentifier) {
            return cell as! T
        } else {
            if Bundle.main.path(forResource: reuseIdentifier, ofType: "nib") != nil {
                register(UINib(nibName: reuseIdentifier, bundle: nil), forCellReuseIdentifier: reuseIdentifier)
            } else {
                register(cellClass, forCellReuseIdentifier: reuseIdentifier)
            }
        }

        return cell(for: cellClass)
    }

    /// Get header of footer of given class
    ///
    /// - parameter headerClass: a header class
    ///
    /// - returns: a reusable view
    func headerOrFooter<T: UITableViewHeaderFooterView>(forClass headerClass: T.Type) -> T {
        let reuseIdentifier = String(describing: headerClass)

        if let cell = self.dequeueReusableHeaderFooterView(withIdentifier: reuseIdentifier) {
            return cell as! T
        } else {
            if Bundle.main.path(forResource: reuseIdentifier, ofType: "nib") != nil {
                register(UINib(nibName: reuseIdentifier, bundle: nil),
                         forHeaderFooterViewReuseIdentifier: reuseIdentifier)
            } else {
                register(headerClass, forHeaderFooterViewReuseIdentifier: reuseIdentifier)
            }
        }
        return headerOrFooter(forClass: headerClass)
    }

    func update(_ updateClosure: () -> Void) {
        UIView.setAnimationsEnabled(false)
        beginUpdates()
        updateClosure()
        endUpdates()
        UIView.setAnimationsEnabled(true)
    }

}
