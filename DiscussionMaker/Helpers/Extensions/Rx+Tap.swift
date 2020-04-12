//
//  Rx+Tap.swift
//  DiscussionMaker
//
//  Created by Artem Trubacheev on 12.04.2020.
//  Copyright © 2020 Artem Trubacheev. All rights reserved.
//

import UIKit
import RxSwift

public extension UIView {

    var didClick: Observable<UITapGestureRecognizer> {
        let tapGesture = UITapGestureRecognizer()
        addGestureRecognizer(tapGesture)
        return tapGesture.rx.event
            .asObservable()
    }

}
