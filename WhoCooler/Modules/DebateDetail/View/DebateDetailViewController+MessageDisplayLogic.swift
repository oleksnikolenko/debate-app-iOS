//
//  DebateDetailViewController+MessageDisplayLogic.swift
//  WhoCooler
//
//  Created by Alex Nikolenko on 09/05/2020.
//  Copyright © 2020 Artem Trubacheev. All rights reserved.
//

import UIKit

protocol MessageDisplayLogic {
    func addNewMessageBatch(_ viewModel: DebateDetail.MessageBatch.ViewModel)
    func addNewRepliesBatch(_ viewModel: DebateDetail.RepliesBatch.ViewModel)

    func addNewMessage(_ viewModel: DebateDetail.MessageSend.ViewModel)
    func addReplyToMessage(_ viewModel: DebateDetail.ReplySend.ViewModel)

    func reloadEditedMessage(_ viewModel: DebateDetail.EditedMessageSend.ViewModel)
    func reloadEditedReply(_ viewModel: DebateDetail.EditedReplySend.ViewModel)

    func deleteMessage(_ viewModel: DebateDetail.DeleteMessage.ViewModel)
    func deleteReply(_ viewModel: DebateDetail.DeleteReply.ViewModel)

    func updateMessageCounter(value: Int)
    func resetTextView()
}

extension DebateDetailViewController {

    // MARK: - Pagination of messages/replies
    func addNewMessageBatch(_ viewModel: DebateDetail.MessageBatch.ViewModel) {
        let firstIndexToReload = sections.count
        let lastIndexToReload = firstIndexToReload + viewModel.cells.count - 1

        tableView.updateWithoutAnimation {
            sections.append(contentsOf: viewModel.cells)
            tableView.insertSections(IndexSet(integersIn: firstIndexToReload...lastIndexToReload), with: .none)
        }
    }

    func addNewRepliesBatch(_ viewModel: DebateDetail.RepliesBatch.ViewModel) {
        for (sectionIndex, section) in sections.enumerated() {
            switch section.section {
            case .message(let message):
                if message.id == viewModel.messageId {
                    let replies: [DebateDetailCellType] = message.replyList.map { .reply($0) }
                    tableView.updateWithoutAnimation {
                        sections[sectionIndex] = (.message(message), rows: [.message(message)] + replies)
                        tableView.reloadSections([sectionIndex], with: .automatic)
                    }

                    let rowIndex = max(0, min(oneReplyBatchCount, replies.count))

                    tableView.scrollToRow(
                        at: IndexPath(row: rowIndex, section: sectionIndex),
                        at: .bottom,
                        animated: true
                    )

                    return
                }
            }
        }
    }

    // MARK: - Adding new message/reply
    func addNewMessage(_ viewModel: DebateDetail.MessageSend.ViewModel) {
        let replies: [DebateDetailCellType] = viewModel.message.replyList.map { .reply($0) }
        tableView.updateWithoutAnimation {
            sections.insert((.message(viewModel.message), rows: [.message(viewModel.message)] + replies), at: 0)
            tableView.insertSections([0], with: .automatic)
        }
        tableView.scrollToRow(at: .init(row: 0, section: 0), at: .bottom, animated: true)
    }

    func addReplyToMessage(_ viewModel: DebateDetail.ReplySend.ViewModel) {
        for (sectionIndex, section) in sections.enumerated() {
            switch section.section {
            case .message(let message):
                if message.id == viewModel.reply.threadId {
                    let reply: DebateDetailCellType = .reply(viewModel.reply)

                    tableView.beginUpdates()
                    sections[sectionIndex].rows.append(reply)
                    let replyIndexPath = IndexPath(row: sections[sectionIndex].rows.count - 1, section: sectionIndex)
                    tableView.insertRows(at: [replyIndexPath], with: .automatic)
                    tableView.endUpdates()

                    tableView.scrollToRow(at: replyIndexPath, at: .bottom, animated: true)

                    return
                }
            }
        }
    }

    // MARK: - Editing message/reply
    func reloadEditedMessage(_ viewModel: DebateDetail.EditedMessageSend.ViewModel) {
        for (sectionIndex, section) in sections.enumerated() {
            switch section.section {
            case .message(let message):
                if viewModel.message.id == message.id {
                    let replies: [DebateDetailCellType] = viewModel.message.replyList.map { .reply($0) }
                    tableView.beginUpdates()
                    sections[sectionIndex] = (.message(viewModel.message), rows: [.message(viewModel.message)] + replies)
                    tableView.reloadSections([sectionIndex], with: .automatic)
                    tableView.endUpdates()

                    return
                }
            }
        }
    }

    func reloadEditedReply(_ viewModel: DebateDetail.EditedReplySend.ViewModel) {
        for (sectionIndex, section) in sections.enumerated() {
            switch section.section {
            case .message:
                for (rowIndex, row) in section.rows.enumerated() {
                    switch row {
                    case .reply(let reply):
                        if reply.id == viewModel.message.id {
                            tableView.beginUpdates()
                            sections[sectionIndex].rows[rowIndex] = .reply(viewModel.message)
                            tableView.reloadRows(at: [IndexPath(row: rowIndex, section: sectionIndex)], with: .none)
                            tableView.endUpdates()

                            return
                        }
                    default:
                        break
                    }
                }
            }
        }
    }

    // MARK: - Deleting message/reply
    func deleteMessage(_ viewModel: DebateDetail.DeleteMessage.ViewModel) {
        for (sectionIndex, section) in sections.enumerated() {
            switch section.section {
            case .message(let message):
                if viewModel.message.id == message.id {
                    tableView.beginUpdates()
                    sections.remove(at: sectionIndex)
                    tableView.deleteSections([sectionIndex], with: .automatic)
                    tableView.endUpdates()

                    return
                }
            }
        }
    }

    func deleteReply(_ viewModel: DebateDetail.DeleteReply.ViewModel) {
        for (sectionIndex, section) in sections.enumerated() {
            switch section.section {
            case .message:
                for (rowIndex, row) in section.rows.enumerated() {
                    switch row {
                    case .reply(let reply):
                        if reply.id == viewModel.message.id {
                            tableView.reloadRows(at: [IndexPath(row: rowIndex, section: sectionIndex)], with: .automatic)
                            sections[sectionIndex].rows.remove(at: rowIndex)
                            return
                        }
                    default:
                        break
                    }
                }
            }
        }
    }

    func updateMessageCounter(value: Int) {
        header.updateMessageCounter(value: value)
    }

    func resetTextView() {
        inputTextView.emptyInput()
    }

}
