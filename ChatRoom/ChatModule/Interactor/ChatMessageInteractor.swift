//
//  ChatMessageInteractor.swift
//  ChatRoom
//
//  Created by Wilson Hung on 2021/5/25.
//

import Foundation

class ChatMessageInteractor: PresenterToInteractorChatProtocol, Paginationable {
    
    var presenter: InteractorToPresenterChatProtocol?
    var pagination: Pagination = Pagination(perPage: 10)
    
    func getFakeData(pagination: Pagination) -> [MessageData] {
        var array: [MessageData] = []
        let demoUser = User(id: "1", displayName: "Wilson", imageURL: "https://library.kissclipart.com/20180901/krw/kissclipart-user-thumbnail-clipart-user-lorem-ipsum-is-simply-bfcb758bf53bea22.jpg")
        
        array.append(MessageData(body: "test1", sender: demoUser))
        array.append(MessageData(body: "test2", sender: demoUser))
        array.append(MessageData(body: "test3", sender: demoUser))
        array.append(MessageData(image: #imageLiteral(resourceName: "IMG_9185 2"), sender: demoUser))
        array.append(MessageData(body: "test4", sender: demoUser))
        array.append(MessageData(body: "test5", sender: demoUser))
        array.append(MessageData(body: "test6", sender: demoUser))
        array.append(MessageData(image: #imageLiteral(resourceName: "IMG_9185 2"), sender: demoUser))
        array.append(MessageData(body: "test7", sender: demoUser))
        array.append(MessageData(body: "test8", sender: demoUser))
        array.append(MessageData(body: "test9", sender: demoUser))
        return array
    }
    
    func fetch() {
        //Note: demo
        pagination.updataTotal(100)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let self = self else { return }
            self.presenter?.fetchSuccess(messages: self.getFakeData(pagination: self.pagination.reset()))
        }
    }
    
    func loadMore() {
        guard pagination.isMore() else {
            return
        }
        //Note: demo
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let self = self else { return }
            self.presenter?.pagingSuccess(messages: self.getFakeData(pagination: self.pagination.next()))
        }
    }
    
    func sendMessage(message: MessageData) {
        presenter?.sendSuccess(message: message)
    }
}
