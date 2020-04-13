//
//  DiscussionDetailWorker.swift
//  DiscussionMaker
//
//  Created by Artem Trubacheev on 09.04.2020.
//  Copyright (c) 2020 Artem Trubacheev. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import RxSwift

class DiscussionDetailWorker {

    let networkService = NetworkServiceImplementation.shared

    func getDebate(id: String) -> Observable<Discussion> {
        networkService.getData(
            endpoint: "debate",
            parameters: ["debate_id": id]
        )
    }

    func getNextMessages(id: String, ctime: Double) -> Observable<MessagesList> {
        networkService.getData(
            endpoint: "messages",
            parameters: ["debate_id": id, "after_time": ctime]
        )
    }

    func vote(debateId: String, sideId: String) -> Observable<Empty> {
        networkService.getData(
            endpoint: "vote",
            parameters: ["debate_id": debateId, "side_id": sideId],
            method: .post
        )
    }
    
}
