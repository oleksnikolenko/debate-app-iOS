//
//  String.swift
//  WhoCooler
//
//  Created by Alex Nikolenko on 13/05/2020.
//  Copyright © 2020 Artem Trubacheev. All rights reserved.
//

import Foundation

extension String {

    var localized: String {
        NSLocalizedString(self, comment: "")
    }

}
