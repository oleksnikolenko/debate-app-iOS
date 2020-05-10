//
//  DebateDetailInteractor.swift
//  DebateMaker
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

protocol DebateDetailBusinessLogic {
    func initDebate(request: DebateDetail.Initializing.Request)
    func reloadDebate()
    func handleSend(request: DebateDetail.SendHandler.Request)
    func vote(request: DebateDetail.Vote.Request)

    func getNextMessagesPage()
    func getNextRepliesPage(request: DebateDetail.RepliesBatch.Request)

    func sendMessage(request: DebateDetail.MessageSend.Request)
    func sendReply(request: DebateDetail.ReplySend.Request)

    func sendEditedMessage(request: DebateDetail.EditedMessageSend.Request)
    func sendEditedReply(request: DebateDetail.EditedReplySend.Request)

    func deleteMessage(request: DebateDetail.DeleteMessage.Request)
    func deleteReply(request: DebateDetail.DeleteReply.Request)

    var currentUser: User? { get }
}

protocol DebateDetailDataStore {}

class DebateDetailInteractor: DebateDetailBusinessLogic, DebateDetailDataStore {

    // MARK: - Properties
    private let oneReplyBatchCount = 5
    let userDefaults = UserDefaultsService.shared
    var presenter: DebateDetailPresentationLogic?
    var worker: DebateDetailWorker
    let disposeBag = DisposeBag()
    var debate: Debate!
    var currentUser: User? { userDefaults.session?.user }

    init() {
        worker = DebateDetailWorker()
    }

    // MARK: Protocol Methods
    func initDebate(request: DebateDetail.Initializing.Request) {
        debate = request.debate
        let response = DebateDetail.Initializing.Response(
            debate: request.debate
        )
        presenter?.presentDebate(response: response)

        worker.getDebate(id: request.debate.id)
            .subscribe(
            onNext: { [weak self] in
                self?.didFetchDebate($0)
            }, onError: { [weak self] in
                self?.handleError($0)
            }).disposed(by: disposeBag)
    }

    func reloadDebate() {
        guard let id = debate?.id else { return }

        worker.getDebate(id: id)
            .subscribe(onNext: { [weak self] in
                self?.didFetchDebate($0)
            }, onError: { [weak self] in
                self?.handleError($0)
            }).disposed(by: disposeBag)
    }

    func handleSend(request: DebateDetail.SendHandler.Request) {
        if let editedMessage = request.editedMessage {
            if request.threadId != nil {
                sendEditedReply(request: .init(message: editedMessage, newText: request.text))
            } else {
                sendEditedMessage(request: .init(messageId: editedMessage.id, newText: request.text))
            }
        } else if let threadId = request.threadId {
            sendReply(request: .init(text: request.text, threadId: threadId))
        } else {
            sendMessage(request: .init(message: request.text))
        }
    }

    func vote(request: DebateDetail.Vote.Request) {
        worker.vote(debateId: debate.id, sideId: request.sideId)
            .subscribe(onNext: { debateVoteResponse in
                self.debate.leftSide.ratingCount = debateVoteResponse.debate.leftSide.ratingCount
                self.debate.leftSide.isVotedByUser = debateVoteResponse.debate.leftSide.isVotedByUser
                self.debate.rightSide.ratingCount = debateVoteResponse.debate.rightSide.ratingCount
                self.debate.rightSide.isVotedByUser = debateVoteResponse.debate.rightSide.isVotedByUser

                self.presenter?.presentVotes(response: .init(debate: debateVoteResponse.debate))
            }, onError: { [weak self] in
                self?.handleError($0)
            }).disposed(by: disposeBag)
    }

    // MARK: - Pagination of messages/replies
    func getNextMessagesPage() {
        guard
            debate?.messagesList.hasNextPage == true,
            let lastTime = debate?.messagesList.messages.last?.createdTime
        else { return }

        worker.getNextMessages(id: debate.id, ctime: lastTime)
            .subscribe(onNext: { [weak self] in
                guard let `self` = self else { return }

                self.debate.messagesList.messages += $0.messages
                self.debate.messagesList.hasNextPage = $0.hasNextPage

                self.presenter?.presentNewMessageBatch(response: .init(messages: $0.messages, hasNextPage: $0.hasNextPage))
            }, onError: { [weak self] in
                self?.handleError($0)
            }).disposed(by: disposeBag)
    }

    func getNextRepliesPage(request: DebateDetail.RepliesBatch.Request) {
        let lastTime = request.parentMessage.replyList.first?.createdTime ?? 0

        worker.getNextReplies(id: request.parentMessage.id, after: lastTime)
            .subscribe(onNext: { [weak self] in
                guard let `self` = self else { return }

                self.debate.messagesList.messages[request.index].replyList =
                    $0.messages + self.debate.messagesList.messages[request.index].replyList

                self.debate.messagesList.messages[request.index].notShownReplyCount -= self.oneReplyBatchCount

                self.presenter?.presentNewRepliesBatch(
                    response: .init(message: self.debate.messagesList.messages[request.index])
                )
            }, onError: { [weak self] in
                self?.handleError($0)
            }).disposed(by: disposeBag)
    }

    // MARK: - Sending new message/reply
    func sendMessage(request: DebateDetail.MessageSend.Request) {
        worker.sendMessage(text: request.message, debateId: debate.id)
            .subscribe(onNext: { [weak self] in
                guard let `self` = self else { return }

                self.debate.messagesList.messages.insert($0, at: 0)
                self.presenter?.presentNewMessage(response: .init(message: $0))
            }, onError: { [weak self] in
                self?.handleError($0)
            }).disposed(by: disposeBag)
    }

    func sendReply(request: DebateDetail.ReplySend.Request) {
        worker.sendReply(text: request.text, threadId: request.threadId)
            .subscribe(onNext: { [weak self] in
                guard
                    let `self` = self,
                    let index = self.getIndexOfMessage(id: request.threadId)
                else { return }
    
                self.debate.messagesList.messages[index].replyList += [$0]
                self.debate.messagesList.messages[index].replyCount += 1

                self.presenter?.presentNewReply(response: .init(
                    message: self.debate.messagesList.messages[index],
                    threadMessage: $0
                ))
            }, onError: { [weak self] in
                self?.handleError($0)
            }).disposed(by: disposeBag)
    }

    // MARK: - Editing message/reply
    func sendEditedMessage(request: DebateDetail.EditedMessageSend.Request) {
        worker.sendEditedMessage(messageId: request.messageId, newText: request.newText)
            .subscribe(onNext: { [weak self] message in
                guard
                    let `self` = self,
                    let index = self.getIndexOfMessage(id: message.id)
                else { return }

                self.debate.messagesList.messages[index] = message
                self.presenter?.presentEditedMessage(response: .init(message: message))
            }, onError: { [weak self] in
                self?.handleError($0)
            }).disposed(by: disposeBag)
    }

    func sendEditedReply(request: DebateDetail.EditedReplySend.Request) {
        worker.sendEditedReply(message: request.message, newText: request.newText)
            .subscribe(onNext: { [weak self] message in
                guard
                    let `self` = self,
                    let threadId = message.threadId,
                    let messageIndex = self.getIndexOfMessage(id: threadId),
                    let replyIndex = self.getIndexOfReply(id: message.id)
                else { return }

                self.debate.messagesList.messages[messageIndex].replyList[replyIndex] = message

                self.presenter?.presentEditedReply(response: .init(message: message))
            }, onError: { [weak self] in
                self?.handleError($0)
            }).disposed(by: disposeBag)
    }

    // MARK: - Deleting message/reply
    func deleteMessage(request: DebateDetail.DeleteMessage.Request) {
        worker.deleteMessage(messageId: request.message.id)
            .subscribe(onNext: { [weak self] response in
                guard
                    let `self` = self, response.success == true,
                    let index = self.getIndexOfMessage(id: request.message.id)
                else { return }

                let message = self.debate.messagesList.messages[index]
                self.debate.messagesList.messages.remove(at: index)

                self.presenter?.deleteMessage(response: .init(message: message))
            }, onError: { [weak self] in
                self?.handleError($0)
            }).disposed(by: disposeBag)
    }

    func deleteReply(request: DebateDetail.DeleteReply.Request) {
        worker.deleteReply(replyId: request.message.id, threadId: request.threadId)
            .subscribe(onNext: { [weak self] response in
                guard
                    let`self` = self, response.success == true,
                    let replyIndex = self.getIndexOfReply(id: request.message.id),
                    let messageIndex = self.getIndexOfMessage(id: request.threadId)
                else { return }

                self.debate.messagesList.messages[safe: messageIndex]?.replyList.remove(at: replyIndex)
                self.debate.messagesList.messages[messageIndex].replyCount -= 1

                self.presenter?.deleteReply(response: .init(message: request.message))
            }, onError: { [weak self] in
                self?.handleError($0)
            }).disposed(by: disposeBag)
    }

    private func handleError(_ error: Error) {
        switch error.type {
        case .noInternet:
            presenter?.presentNoInternet()
        case .unauthorized:
            presenter?.presentAuthScreen()
        case .unknown:
            /// TODO - Handle error
            break
        }
    }

    // MARK: - Private Methods
    private func didFetchDebate(_ debate: Debate) {
        self.debate = debate
        presenter?.presentDebate(response: .init(debate: debate))
    }

    private func getIndexOfMessage(id: String) -> Int? {
        var indexSection: Int? = nil
        debate.messagesList.messages.enumerated().forEach { index, message in
            if message.id == id {
                indexSection = index
                return
            }
        }
        return indexSection
    }

    private func getIndexOfReply(id: String) -> Int? {
        var indexSection: Int? = nil
        debate.messagesList.messages.enumerated().forEach { index, message in
            message.replyList.enumerated().forEach { index, threadMessage in
                if threadMessage.id == id {
                    indexSection = index
                    return
                }
            }
        }
        return indexSection
    }

}
