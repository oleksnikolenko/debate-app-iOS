//
//  ShimmerView.swift
//  WhoCooler
//
//  Created by Alex Nikolenko on 17/05/2020.
//  Copyright © 2020 Artem Trubacheev. All rights reserved.
//

import UIKit

class ShimmerView: UIView {

    // MARK: - Properties
    var gradientColorOne : CGColor = UIColor(white: 0.85, alpha: 1.0).cgColor
    var gradientColorTwo : CGColor = UIColor(white: 0.95, alpha: 1.0).cgColor

    // MARK: - Public methods
    func addGradientLayer(cornerRadius: CGFloat) -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()

        gradientLayer.frame = bounds
        gradientLayer.cornerRadius = cornerRadius
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.colors = [gradientColorOne, gradientColorTwo, gradientColorOne]
        gradientLayer.locations = [0.0, 0.5, 1.0]

        layer.addSublayer(gradientLayer)

        return gradientLayer
    }

    func addAnimation() -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "locations")

        animation.fromValue = [-1.0, -0.5, 0.0]
        animation.toValue = [1.0, 1.5, 2.0]
        animation.repeatCount = .infinity
        animation.duration = 0.9

        return animation
    }

    func startAnimating(cornerRadius: CGFloat = 14) {
        let gradientLayer = addGradientLayer(cornerRadius: cornerRadius)
        let animation = addAnimation()

        gradientLayer.add(animation, forKey: animation.keyPath)
    }

}
