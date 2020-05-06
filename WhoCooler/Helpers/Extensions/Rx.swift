//
//  Rx.swift
//  WhoCooler
//
//  Created by Artem Trubacheev on 12.04.2020.
//  Copyright © 2020 Artem Trubacheev. All rights reserved.
//

import RxSwift

public extension UIView {

    var didClick: Observable<Void> {
        let tapGesture = UITapGestureRecognizer()
        addGestureRecognizer(tapGesture)
        return tapGesture.rx.event
            .map { _ in }
            .asObservable()
    }

}

public extension ObservableType {

    func skipNil<T>() -> Observable<T> where Element == T? { flatMap { Observable.from(optional: $0) } }

}

