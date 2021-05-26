//
//  MessageData.swift
//  ChatRoom
//
//  Created by Wilson Hung on 2021/5/25.
//

import UIKit

enum MsgType: Int {
    case text = 1
    case image = 2
    case restricted = 3
}

struct MessageData {
    var id: String?
    var chatroom_id: String?
    var bodyType: MsgType = .text
    var body: String?
    var sender: User?
    var created_at: String?
    var updated_at: String?
    var entity_id: String?
    var mediaUrl: String?
    var tmp_id: String?
    var isLoading = false
    var image: UIImage?
    var ratio: Double?
    var enabled = true
    
    //Note: demo
    init(body: String, sender: User? = UserManager.shared.currentUser) {
        self.id = UUID().uuidString
        self.body = body
        self.bodyType = .text
        self.tmp_id = UUID().uuidString
        self.sender = sender
    }
    
    //Note: demo
    init(image: UIImage, sender: User? = UserManager.shared.currentUser) {
        self.id = UUID().uuidString
        self.image = image//.resizeImage(maxSize: UIScreen.main.bounds.width)
        self.ratio = Double(image.size.width / image.size.height)
        self.bodyType = .image
        self.tmp_id = UUID().uuidString
        self.sender = sender
    }

}
