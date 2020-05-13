//
//  DateFormatter.swift
//  SUHelpers
//
//  Created by Alex Nikolenko on 26/04/2020.
//  Copyright © 2020 Artem Trubacheev. All rights reserved.
//

import Foundation

public extension DateFormatter {

    internal static func date(with dateFormat: DateFormat) -> DateFormatter {
        return DateFormatter().with {
            $0.dateFormat = dateFormat.makeDate(localization: Localization(rawValue: Locale.current.languageCode ?? "en") ?? .en)
        }
    }

}

enum DateFormat {
    case dayMonthYear
    case monthDay
}

extension DateFormat {

    func makeDate(localization: Localization) -> String {
        switch self {
        case .dayMonthYear:
            return localization.dayMonthYear
        case .monthDay:
            return localization.monthDay
        }
    }

}

enum Localization: String {
    case en, ru
}

extension Localization {

    var asLocale: Locale { Locale(identifier: rawValue) }

    var dayMonthYear: String {
        switch self {
        case .en:
            return "MMMM d, yyyy"
        case .ru:
            return "d MMMM, yyyy"
        }
    }

    var monthDay: String {
        switch self {
        case .en:
            return "MMMM d"
        case .ru:
            return "d MMMM"
        }
    }

}
