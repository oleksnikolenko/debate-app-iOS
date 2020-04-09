//
//  NetworkService.swift
//  DiscussionMaker
//
//  Created by Artem Trubacheev on 07.04.2020.
//  Copyright © 2020 Artem Trubacheev. All rights reserved.
//

import Alamofire
import RxSwift

protocol NetworkService {

    func getData<T: Decodable>(
        endpoint: String,
        parameters: [String: Any],
        method: HTTPMethod
    ) -> Observable<T>

}

class NetworkServiceImplementation: NetworkService {

    static let shared = NetworkServiceImplementation()

    let baseUrl = "https://whocooler.com/"

    private init () {}

    func getData<T: Decodable>(
        endpoint: String,
        parameters: [String: Any] = [:],
        method: HTTPMethod = .get
    ) -> Observable<T> {
        let response = PublishSubject<T>()

        AF.request(
            baseUrl + endpoint,
            method: method,
            parameters: parameters
        ).responseData {
            guard let data = $0.data else {
                response.onError(AFError.explicitlyCancelled)
                return
            }

            let debates = try? JSONDecoder().decode(T.self, from: data)

            guard let unwrappedDebates = debates else {
                response.onError(AFError.explicitlyCancelled)
                return
            }

            response.onNext(unwrappedDebates)
        }

        return response
    }

}
