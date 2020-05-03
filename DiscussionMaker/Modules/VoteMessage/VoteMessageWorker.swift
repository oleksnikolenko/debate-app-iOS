//
//  VoteMessageWorker.swift
//  DiscussionMaker
//
//  Created by Alex Nikolenko on 30/04/2020.
//  Copyright © 2020 Artem Trubacheev. All rights reserved.
//

import Alamofire
import RxSwift

class VoteMessageWorker {

    let networkService = NetworkServiceImplementation.shared

    func postVote(objectId: String, voteType: VoteType) -> Observable<VoteModel> {
        networkService.getData(
            endpoint: "messagevote",
            parameters: [
                "is_positive": voteType == .up ? true : false,
                "message_id": objectId
            ],
            method: .post,
            shouldLocalize: false
        )
    }

    func deleteVote(objectId: String) -> Observable<VoteModel> {
        networkService.getData(
            endpoint: "messagevote",
            parameters: [
                "message_id": objectId
            ],
            method: .delete,
            shouldLocalize: false
        )
    }

}
