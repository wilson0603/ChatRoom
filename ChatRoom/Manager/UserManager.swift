//
//  UserManager.swift
//  ChatRoom
//
//  Created by Wilson Hung on 2021/5/25.
//

import Foundation

class UserManager {
    static let shared = UserManager()
    var currentUser: User? = User(id: "2", displayName: "Customer", imageURL: "https://library.kissclipart.com/20180901/krw/kissclipart-user-thumbnail-clipart-user-lorem-ipsum-is-simply-bfcb758bf53bea22.jpg")
}
