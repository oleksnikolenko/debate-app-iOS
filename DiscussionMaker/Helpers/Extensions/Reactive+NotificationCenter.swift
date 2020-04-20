//
//  Reactive+NotificationCenter.swift
//  DiscussionMaker
//
//  Created by Artem Trubacheev on 19.04.2020.
//  Copyright © 2020 Artem Trubacheev. All rights reserved.
//

import RxSwift

extension Reactive where Base: NotificationCenter {

    var keyboardInfo: Observable<(CGFloat, Double, UInt)> {
        Observable.combineLatest(
            keyboardHeight,
            keyboardAnimationDuration,
            keyboardAnimationCurve
        )
    }

    private var keyboardHeight: Observable<CGFloat> {
        let willShowKeyboardHeight = willShowKeyboardNotification
            .map { $0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue }
            .map { $0?.cgRectValue.height }
            .compactMap { $0 }
        let willHideKeyboardHeight = willHideKeyboardNotification.map { _ in CGFloat(0) }

        return Observable.merge(willShowKeyboardHeight, willHideKeyboardHeight)
    }

    private var keyboardAnimationDuration: Observable<Double> {
        Observable
            .merge(willShowKeyboardNotification, willHideKeyboardNotification)
            .map { $0.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double }
            .map { $0 ?? 0 }
    }

    private var keyboardAnimationCurve: Observable<UInt> {
        Observable
            .merge(willShowKeyboardNotification, willHideKeyboardNotification)
            .map { $0.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt }
            .map { $0 ?? 0 }
    }

    private var willShowKeyboardNotification: Observable<Notification> {
        NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
    }

    private var willHideKeyboardNotification: Observable<Notification> {
        NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
    }

}
