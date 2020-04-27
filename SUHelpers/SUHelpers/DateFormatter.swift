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
            $0.dateFormat = dateFormat.makeDate()
        }
    }

}

enum DateFormat {
    case dayMonthYear
    case monthDay
}

extension DateFormat {

    func makeDate() -> String {
        switch self {
        case .dayMonthYear:
            return "MMMM d, yyyy"
        case .monthDay:
            return "MMMM d"
        }
    }

}
