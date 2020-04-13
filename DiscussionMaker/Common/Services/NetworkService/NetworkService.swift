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
        method: HTTPMethod,
        shouldUseRefreshToken: Bool
    ) -> Observable<T>

}

class NetworkServiceImplementation: NetworkService {

    static let shared = NetworkServiceImplementation()

    let baseUrl = "https://api.whocooler.com/"
    let disposeBag = DisposeBag()

    private init () {}
    private let userDefaults = UserDefaultsService.shared

    func getData<T: Decodable>(
        endpoint: String,
        parameters: [String: Any] = [:],
        method: HTTPMethod = .get,
        shouldUseRefreshToken: Bool = false
    ) -> Observable<T> {
        let response = PublishSubject<T>()

        var headers = HTTPHeaders()

        if let session = userDefaults.session {
            headers.add(
                name: "Authorization",
                value: "Bearer \(shouldUseRefreshToken ? session.refreshToken : session.accessToken)"
            )
        }

        AF.request(
            baseUrl + endpoint,
            method: method,
            parameters: parameters,
            headers: headers
        ).responseData { [unowned self] in
            #if DEBUG
            if let data = $0.data {
                print(String(data: data, encoding: .utf8))
            }
            #endif

            if ($0.response?.statusCode.distance(to: 450) ?? 0) <= 50 {
                self.refreshToken()
                    .flatMap { [unowned self] _ -> Observable<T> in
                        self.getData(
                            endpoint: endpoint,
                            parameters: parameters,
                            method: method,
                            shouldUseRefreshToken: shouldUseRefreshToken
                        )
                    }
                .bind(to: response)
                .disposed(by: self.disposeBag)
            }
            guard let data = $0.data else {
                response.onError($0.error ?? AFError.explicitlyCancelled)
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

    func refreshToken() -> Observable<RefreshTokenResult> {
        getData(
            endpoint: "refresh",
            method: .get,
            shouldUseRefreshToken: true
        ).do(onNext: { [weak self] in
            self?.userDefaults.session?.accessToken = $0.accessToken
        })
    }

}
