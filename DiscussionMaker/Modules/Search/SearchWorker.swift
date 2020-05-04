//
//  SearchWorker.swift
//  DiscussionMaker
//
//  Created by Alex Nikolenko on 04/05/2020.
//  Copyright © 2020 Artem Trubacheev. All rights reserved.
//

import Alamofire
import RxSwift

class SearchWorker {

    let networkService = NetworkServiceImplementation.shared

    func search(context: String, page: Int) -> Observable<SearchResponse> {
        return networkService.getData(
            endpoint: "search",
            parameters: ["search_context": context, "page": page],
            method: .get,
            shouldLocalize: false
        )
    }
}
