//
//  DataPicker.swift
//  DiscussionMaker
//
//  Created by Artem Trubacheev on 25.04.2020.
//  Copyright © 2020 Artem Trubacheev. All rights reserved.
//

import UIKit

typealias ImageFetchCompletion = (UIImage?) -> ()

protocol DataPicker {
    func tryToFetchImage(vc: UIViewController, completion: @escaping ImageFetchCompletion)
}
