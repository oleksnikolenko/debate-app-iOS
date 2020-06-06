//
//  PickCategoryWorker.swift
//  WhoCooler
//
//  Created by Artem Trubacheev on 06.06.2020.
//  Copyright (c) 2020 Artem Trubacheev. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import RxSwift

class PickCategoryWorker {

    let networkService = NetworkServiceImplementation.shared

    func getCategories() -> Observable<CategoriesResponse> {
        networkService.getData(
            endpoint: "categories",
            shouldLocalize: true
        )
    }

}
