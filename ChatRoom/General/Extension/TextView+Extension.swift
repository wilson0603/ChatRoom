//
//  TextView+Extension.swift
//  ChatRoom
//
//  Created by Wilson Hung on 2021/5/25.
//

import UIKit

extension UITextView {
    
    func setZeroPadding() { // remove textView default padding
        textContainerInset = UIEdgeInsets.zero
        textContainer.lineFragmentPadding = 0
    }
    
    func lineHeight() -> CGFloat { // get line height
        
        if let height = font?.lineHeight {
           return CGFloat(ceil(Double(height)))
        }
        return 0
    }
    
    func LineHeightWithContainerInset() -> CGFloat { // get minimum height
        
        if let height = font?.lineHeight {
           return CGFloat(ceil(Double(height))) + textContainerInset.top + textContainerInset.bottom
        }
        return 0
    }
}
