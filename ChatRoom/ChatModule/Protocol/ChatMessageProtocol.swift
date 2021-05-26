//
//  ChatMessageProtocol.swift
//  ChatRoom
//
//  Created by Wilson Hung on 2021/5/26.
//

import Foundation

protocol ViewToPresenterChatProtocol: class {
    var messages: [MessageData] { get set }
    var view: PresenterToViewChatProtocol? { get set }
    var interactor: PresenterToInteractorChatProtocol? { get set }
    func startFetching()
    func startPaging()
}

protocol PresenterToViewChatProtocol: class {
    func setLoading(bool: Bool)
    func reloadData()
    func showEmptySections()
    func showGettingSectionsFailed()
    func messageUpdate(at row: Int)
    func messageRemove(at row: Int)
    func newMessageReload()
    func pagingReload()
}

protocol PresenterToInteractorChatProtocol:class {
    var presenter:InteractorToPresenterChatProtocol? {get set}
    func fetch()
    func loadMore()
    func sendMessage(message: MessageData)
}

protocol InteractorToPresenterChatProtocol:class {
    func fetchSuccess(messages: Array<MessageData>)
    func pagingSuccess(messages: Array<MessageData>)
    func sendSuccess(message: MessageData)
    func fetchFailed()
}
