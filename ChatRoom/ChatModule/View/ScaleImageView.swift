//
//  ScaleImageView.swift
//  ChatRoom
//
//  Created by Wilson Hung on 2021/5/25.
//

import UIKit

class ScaleImageView: UIImageView {
    
    var maxRatio: CGFloat?
    var minRatio: CGFloat?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setScale(aspect: 1)
    }
    
    var aspectConstraint : NSLayoutConstraint? {
        didSet {
            if oldValue != nil {
                self.removeConstraint(oldValue!)
            }
            if aspectConstraint != nil {
                self.addConstraint(aspectConstraint!)
            }
        }
    }

    func setScale(aspect: CGFloat) {
        var aspect = aspect
        if let maxRatio = maxRatio {
            if aspect > maxRatio {
                aspect = maxRatio
            }
        }
        if let minRatio = minRatio {
            if aspect < minRatio {
                aspect = minRatio
            }
        }
        let constraint = NSLayoutConstraint(item: self, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.height, multiplier: aspect, constant: 0.0)
        constraint.priority = UILayoutPriority(rawValue: 999)
        aspectConstraint = constraint
    }
}
