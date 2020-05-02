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

    func postVote(objectId: String, voteType: VoteType, style: MessageStyle) -> Observable<VoteModel> {
        let objectIdParameterName = style == .message ? "message_id" : "thread_id"

        return networkService.getData(
            endpoint: "messagevote",
            parameters: [
                "is_positive": voteType == .up ? true : false,
                objectIdParameterName: objectId
            ],
            method: .post,
            shouldLocalize: false
        )
    }

    func deleteVote(objectId: String, style: MessageStyle) -> Observable<VoteModel> {
        let objectIdParameterName = style == .message ? "message_id" : "thread_id"

        return networkService.getData(
            endpoint: "messagevote",
            parameters: [objectIdParameterName: objectId],
            method: .delete,
            shouldLocalize: false
        )
    }

}
