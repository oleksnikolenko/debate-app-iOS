//
//  CreateDebateWorker.swift
//  WhoCooler
//
//  Created by Artem Trubacheev on 31.05.2020.
//  Copyright (c) 2020 Artem Trubacheev. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import RxSwift

class CreateDebateWorker {

    let networkService: NetworkService = NetworkServiceImplementation.shared

    func createDebate(
        leftName: String,
        rightName: String,
        leftImage: UIImage,
        rightImage: UIImage,
        categoryId: String,
        name: String?
    ) -> Observable<Debate> {
        networkService.sendData(
            endpoint: "debatecreate",
            parameters: [
                "leftside_name": leftName,
                "leftside_image": leftImage,
                "rightside_name": rightName,
                "rightside_image": rightImage,
                "category_id": categoryId,
                "name": name
            ],
            method: .post,
            shouldLocalize: true
        )
    }

}
