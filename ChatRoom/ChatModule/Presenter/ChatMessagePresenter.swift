//
//  ChatMessagePresenter.swift
//  Yogerit
//
//  Created by Wilson on 2020/1/30.
//  Copyright © 2020 Yoger Inc. All rights reserved.
//

import Foundation

class ChatMessagePresenter: ViewToPresenterChatProtocol {
    
    var messages: [MessageData] = []
    var user_id: String?

    var view: PresenterToViewChatProtocol?
    var interactor: PresenterToInteractorChatProtocol?
    
    func startFetching() {
        view?.setLoading(bool: true)
        interactor?.fetch()
    }
    
    func startPaging() {
        view?.setLoading(bool: true)
        interactor?.loadMore()
    }
}

extension ChatMessagePresenter: InteractorToPresenterChatProtocol {
    
    func fetchSuccess(messages: Array<MessageData>) {
        self.messages = messages
        view?.reloadData()
        view?.setLoading(bool: false)
    }
    
    func pagingSuccess(messages: Array<MessageData>) {
        self.messages = messages + self.messages
        view?.pagingReload()
        view?.setLoading(bool: false)
    }
    
    func sendSuccess(message: MessageData) {
        self.messages.append(message)
        view?.newMessageReload()
    }
    
    func fetchFailed() {
        view?.showGettingSectionsFailed()
    }
    
}
