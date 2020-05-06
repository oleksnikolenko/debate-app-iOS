//
//  NetworkService.swift
//  WhoCooler
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
        shouldLocalize: Bool
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
        shouldLocalize: Bool = false
    ) -> Observable<T> {
        let response = PublishSubject<T>()

        var headers = HTTPHeaders()

        if let session = userDefaults.session {
            headers.add(
                name: "Authorization",
                value: "Bearer \(session.accessToken)"
            )
        }

        let url: String
        if shouldLocalize {
            url = baseUrl + "en/" + endpoint
        } else {
            url = baseUrl + endpoint
        }

        AF.request(
            url,
            method: method,
            parameters: parameters,
            headers: headers
        ).responseData { [unowned self] in
            #if DEBUG
            if let data = $0.data {
                print(String(data: data, encoding: .utf8))
            }
            #endif

            if ($0.response?.statusCode == 422 || $0.response?.statusCode == 401) {
                self.refreshToken()
                    .flatMap { [unowned self] event -> Observable<T> in
                        self.getData(
                            endpoint: endpoint,
                            parameters: parameters,
                            method: method
                        )
                    }
                    .bind(to: response)
                    .disposed(by: self.disposeBag)
            }
            guard let data = $0.data else {
                response.onError($0.error ?? AFError.explicitlyCancelled)
                return
            }

            do {
                let debates = try JSONDecoder().decode(T.self, from: data)
                response.onNext(debates)
            } catch {
                response.onError(error)
            }
        }

        return response
    }

    func refreshToken() -> Observable<RefreshTokenResult> {
        let response = PublishSubject<RefreshTokenResult>()
        var headers = HTTPHeaders()

        if let session = userDefaults.session {
            headers.add(
                name: "Authorization",
                value: "Bearer \(session.refreshToken)"
            )
        }

        AF.request(
            baseUrl + "refresh",
            headers: headers
        ).responseData {
            #if DEBUG
            if let data = $0.data {
                print(String(data: data, encoding: .utf8))
            }
            #endif
            guard let data = $0.data else {
                response.onError($0.error ?? AFError.explicitlyCancelled)
                return
            }

            do {
                let debates = try JSONDecoder().decode(RefreshTokenResult.self, from: data)
                response.onNext(debates)
            } catch {
                response.onError(error)
            }
        }

        return response
            .do(onNext: { [weak self] in
                self?.userDefaults.session?.accessToken = $0.accessToken
            })
    }

    func updateProfile<T: Decodable>(
        name: String?,
        avatar: UIImage?
    ) -> Observable<T> {
        let response = PublishSubject<T>()
        let url = baseUrl + "useredit"

        var headers = HTTPHeaders()
        if let session = userDefaults.session {
            headers.add(
                name: "Authorization",
                value: "Bearer \(session.accessToken)"
            )
        }

        AF.upload(
            multipartFormData: { multipartFormData in
                if let imageData = avatar?.jpegData(compressionQuality: 0.1) {
                    multipartFormData.append(
                        imageData,
                        withName: "avatar",
                        fileName: "avatar.jpeg",
                        mimeType: "image/jpeg"
                    )
                }
                if let name = name?.data(using: .utf8) {
                    multipartFormData.append(name, withName: "name")
                }
            },
            to: url,
            method: .patch,
            headers: headers
        ).responseData {
            #if DEBUG
            if let data = $0.data {
                print(String(data: data, encoding: .utf8))
            }
            #endif
            guard let data = $0.data else {
                response.onError($0.error ?? AFError.explicitlyCancelled)
                return
            }

            do {
                let debates = try JSONDecoder().decode(T.self, from: data)
                response.onNext(debates)
            } catch {
                response.onError(error)
            }
        }

        return response
    }

}