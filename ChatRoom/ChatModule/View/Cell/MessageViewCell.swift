//
//  OutgoingMessageCollectionViewCell.swift
//  Yogerit
//
//  Created by Dars on 2017/11/16.
//  Copyright © 2017年 Yoger Inc. All rights reserved.
//

import UIKit
import Kingfisher

protocol MessageViewDelegate: class {
    func didClickAvatarImage(incoming: Bool)
    func didClickDestroy(key: String)
}

class MessageViewCell: UITableViewCell {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var friendName: UILabel!
    @IBOutlet weak var messageLabelView: UIView!
    @IBOutlet weak var messageLabel: UITextView!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var messageImageView: ScaleImageView!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var horizontalStackView: UIStackView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var contentStackView: UIStackView!
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var loadingActivityView: UIActivityIndicatorView!
 
    var message: MessageData?
    var currentType = cellType.incoming
    weak var delegate: MessageViewDelegate?
    
    enum cellType {
        case incoming
        case outgoing
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
        self.backgroundColor = UIColor.clear
      
        avatarImageView.isUserInteractionEnabled = true
        avatarImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.didClickAvatarImage)))
        messageImageView.layer.cornerRadius = 5
        messageImageView.isUserInteractionEnabled = true
        messageImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.didClickImage)))
        //messageImageView.kf.indicatorType = .activity
        timestampLabel.textColor = .gray
        timestampLabel.adjustsFontSizeToFitWidth = true
        loadingActivityView.hidesWhenStopped = true
        messageLabel.textContainerInset.left = 12
        messageLabel.textContainerInset.right = 12
        messageLabel.font = UIFont.preferredFont(forTextStyle: .callout)
        let lineHeight = messageLabel.LineHeightWithContainerInset()
        messageLabelView.layer.cornerRadius = lineHeight / 2
        messageLabelView.snp.makeConstraints { (make) in
            make.width.greaterThanOrEqualTo(lineHeight)
        }
      
        dateView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(self.didLongPressCell(_:))))
        contentStackView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(self.didLongPressCell(_:))))
    }
    
    func displayCell(message: MessageData, type: cellType, row: Int) {

        self.message = message
        self.currentType = type

        if type == .incoming {

            messageLabel.linkTextAttributes = [NSAttributedString.Key.foregroundColor : messageLabel.tintColor ?? .blue]
            messageLabelView.backgroundColor = #colorLiteral(red: 0.9215686275, green: 0.9215686275, blue: 0.9215686275, alpha: 1)
            messageLabel.textColor = .black
            
            
            friendName.isHidden = false
            avatarImageView.isHidden = false
            friendName.text = message.sender?.displayName
            avatarImageView.kf_setImage(urlPath: message.sender?.imageURL)
           
        }else {

            messageLabel.linkTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue]
            messageLabelView.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
            messageLabel.textColor = .white
            friendName.isHidden = true
            avatarImageView.isHidden = true
 
        }
  
        if message.isLoading {
            loadingActivityView.startAnimating()
            timestampLabel.isHidden = true
        }else {
            loadingActivityView.stopAnimating()
            timestampLabel.isHidden = false
        }
        
        timestampLabel.text = message.created_at
        messageImageView.image = nil
        
        switch message.bodyType {
        case .text, .restricted:
            messageLabelView.isHidden = false
            messageView.isHidden = true
            if message.bodyType == .text {
                messageLabel.text = message.body
                messageLabel.font = UIFont.preferredFont(forTextStyle: .callout)
 
            }else if message.bodyType == .restricted {
                messageLabel.font = UIFont.preferredFont(forTextStyle: .callout)
                messageLabel.textColor = messageLabel.textColor?.withAlphaComponent(0.8)
            }
      
        case .image:
            messageLabelView.isHidden = true
            messageView.isHidden = false
            messageImageView.setScale(aspect: CGFloat(message.ratio ?? 1))
            messageImageView.kf_setImage(urlPath: message.mediaUrl, placeholder: message.image)
        }
    }

    @objc func didLongPressCell(_ gesture: UIGestureRecognizer) {
        
        guard gesture.state == .began, let message = message, message.bodyType != .restricted else {
            return
        }
        
        let view: UIView = (message.bodyType == .text) ? messageLabelView : messageView
        
        let menuController = UIMenuController.shared
        
        var items: [UIMenuItem] = []
        
        if message.id != nil, self.currentType == .outgoing {
            let deleteItem = UIMenuItem(title: "Delete", action: #selector(self.didClickDelete))
            items.append(deleteItem)
        }
        
        if message.bodyType == .text {
            let copyItem = UIMenuItem(title: "Copy", action: #selector(self.didClickCopy))
            items.append(copyItem)
        }
        
        if items.count == 0 {
            return
        }
        
        self.becomeFirstResponder()
        menuController.menuItems = items
        menuController.arrowDirection = .down
        menuController.setTargetRect(view.bounds, in: view)
        menuController.setMenuVisible(true, animated: true)
        
    }

    @objc func didClickDelete() {
        
        if let key = self.message?.id {
            self.delegate?.didClickDestroy(key: key)
        }
    }
    @objc func didClickCopy() {
        let pasteboard = UIPasteboard.general
        pasteboard.string = messageLabel.text
    }
    
    @objc func didClickAvatarImage() {
        self.delegate?.didClickAvatarImage(incoming: currentType == .incoming)
    }
    
    @objc func didClickImage() {
        
//        if let url = message?.mediaUrl {
//            messageImageView.pop(path: url)
//        }
        messageImageView.pop()
    }

    override var canBecomeFirstResponder : Bool {
        return true
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if (action == #selector(self.didClickCopy) || action == #selector(self.didClickDelete)) {
            return true
        } else {
            return false
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        friendName.text = nil
        avatarImageView.image = nil
        messageImageView.image = nil
        avatarImageView.kf_cancelDownloadTask()
        messageImageView.kf_cancelDownloadTask()
    }
}

