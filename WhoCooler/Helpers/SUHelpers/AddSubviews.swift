//
//  AddSubviews.swift
//  SUHelpers
//
//  Created by Artem Trubacheev on 26.01.2020.
//  Copyright © 2020 Artem Trubacheev. All rights reserved.
//

import UIKit

public extension UIView {

    func addSubviews(_ subviews: [UIView]) {
        subviews.forEach { addSubview($0) }
    }

    func addSubviews(_ subviews: UIView...) {
        addSubviews(subviews)
    }

}
