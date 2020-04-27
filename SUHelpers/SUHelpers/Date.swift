//
//  Date.swift
//  SUHelpers
//
//  Created by Alex Nikolenko on 26/04/2020.
//  Copyright © 2020 Artem Trubacheev. All rights reserved.
//

import Foundation

public extension Date {

    var dateSinceNow: String {
        let seconds = Int(-timeIntervalSinceNow)

        let minutes = seconds / 60
        let hours = minutes / 60
        let days = hours / 24

        if isLastYear {
            return DateFormatter.date(with: .dayMonthYear).string(from: self)
        }
        if days == 1 {
            return days.description + "d"
        } else if days > 1 {
            return DateFormatter.date(with: .monthDay).string(from: self)
        }
        if hours > 0 {
            return hours.description + "h"
        }
        if minutes > 0 {
            return minutes.description + "m"
        }

        return "now"
    }

    var isLastYear: Bool {
        if (Calendar.current.component(.year, from: Date()) - Calendar.current.component(.year, from: self)) > 0 {
            return true
        }
        return false
    }

}
