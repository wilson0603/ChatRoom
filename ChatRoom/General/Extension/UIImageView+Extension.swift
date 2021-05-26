//
//  UIImageView+Extension.swift
//  ChatRoom
//
//  Created by Wilson Hung on 2021/5/25.
//

import Foundation
import UIKit
import Kingfisher

typealias ImageBlock = (UIImage?, NSError?) -> Void

extension UIImageView {

    func kf_setImage(urlPath: String?, placeholder: UIImage? = nil, cacheMemoryOnly: Bool? = nil) {
       
        if let urlPath = urlPath, let url = URL(string: urlPath) {
            self.kf.setImage(with: ImageResource(downloadURL: url), placeholder:  placeholder, options: cacheMemoryOnly == true ? [.cacheMemoryOnly] : nil, progressBlock: nil)
        }else {
            self.image = placeholder
        }
    }

    func kf_cancelDownloadTask() {
        self.kf.cancelDownloadTask()
    }
}

extension UIImageView {
    
    func pop(path: String? = nil) {
        
        guard self.image != nil else {
            return
        }
        
        let postImage = PostImage()
        
        if let path = path {
            postImage.storagePath = path
        }else {
            postImage.image = image
        }
        postImage.tempImage = image
        
        let vc = ImagePageViewController(parentImageView: self, index: 0, images: [postImage])
        UIApplication.topViewController()?.present(vc, animated: true, completion: nil)

    }
 
}
