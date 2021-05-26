//
//  PostImage.swift
//  ChatRoom
//
//  Created by Wilson Hung on 2021/5/25.
//

import UIKit

class PostImage {
    var image: UIImage? {
        didSet {
            if let image = image {
                self.ratio = Double(image.size.width / image.size.height)
            }
        }
    }
    var storagePath: String?
    var isCover: Bool = false
    var tempImage: UIImage?
    var ratio: Double?
    var timeStamp: Double?
    //var phAsset: PHAsset?
    
    enum Mode {
        case full
        case profile
        case list
        case medium
        case badge
    }

    init() {
        self.image = nil
        self.storagePath = nil
        self.isCover = false
        self.timeStamp = Date().timeIntervalSince1970
    }
    
    init(path: String?) {
        self.image = nil
        self.storagePath = path
        self.isCover = false
    }
    
    init(image: UIImage) {
        self.image = image
        self.storagePath = nil
        self.isCover = false
        self.ratio = Double(image.size.width / image.size.height)
    }
}
