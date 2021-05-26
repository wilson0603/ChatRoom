//
//  TextViewBar.swift
//  Yogerit
//
//  Created by Wilson on 2019/8/28.
//  Copyright © 2019 Yoger Inc. All rights reserved.
//

import UIKit

protocol TextViewBarDelegate: class {
    func didPressLeftButton()
    func didPressRightButton()
}

class TextViewBar: UIView {
    
    @IBOutlet weak var backgroundView: UIStackView!
    @IBOutlet weak var photoButton: UIButton!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet weak var textView: GrowingTextView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var addtionalLabel: UILabel!
    @IBOutlet weak var addtionalView: UIView!
  
    var bottomConstraint: NSLayoutConstraint!
    var textViewHeight: CGFloat = 0

    weak var delegate: TextViewBarDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setupUI()
    }
  
    override var intrinsicContentSize: CGSize {
        return CGSize.zero
    }
    
    @IBAction func didClickCancelEditButton(_ sender: Any) {
        setEditing(false)
        clearText()
    }
    
    @IBAction func didClickSendButton(_ sender: Any) {
        
        delegate?.didPressRightButton()
    }
    
    @IBAction func didClickPhotoButton(_ sender: Any) {
        
        textView.resignFirstResponder()
        delegate?.didPressLeftButton()
    }
    
    func clearText() {
        self.textView.text = nil
        self.textView.layoutIfNeeded()
        self.setButtonEnable()
        self.setEditing(false)
    }
}

private extension TextViewBar {
    
    func setupUI() {
        self.addTopLine()
        addtionalView.isHidden = true
        loading.isHidden = true
        sendButton.isEnabled = false
        textView.delegate = self
        textView.layer.borderWidth = 0.5
        textView.layer.borderColor = #colorLiteral(red: 0.8392156863, green: 0.8392156863, blue: 0.8392156863, alpha: 1)
        textView.textContainerInset.left = 8
        textView.textContainerInset.right = 8
        textView.placeholder = "Enter here"
        textView.trimWhiteSpaceWhenEndEditing = true
        textView.font = UIFont.systemFont(ofSize: 15)
        textView.layer.cornerRadius = textView.LineHeightWithContainerInset() / 2
        textView.maxHeight = 156
        autoresizingMask = .flexibleHeight
    }
    
    func setIsLoading(_ bool: Bool) {
        photoButton.isEnabled = !bool
        sendButton.isHidden = bool
        loading.isHidden = !bool
        if bool {
            loading.startAnimating()
        }else {
            loading.stopAnimating()
        }
    }
    
    func setEditing(_ bool: Bool, text: String? = nil, showPhotoButton: Bool = false) {
        addtionalLabel.text = text
        if bool {
            if showPhotoButton == false {
                photoButton.isHidden = true
            }
            addtionalView.isHidden = false
        }else {
            photoButton.isHidden = false
            addtionalView.isHidden = true
        }
    }
    
    func setEnabled(_ bool: Bool) {
        photoButton.isEnabled = bool
        textView.isEditable = bool
        if bool {
            setButtonEnable()
        }else {
            sendButton.isEnabled = false
        }
    }
    
    func layout(view: UIView, shouldHideTextViewBar:Bool) {
        view.addSubview(self)
        self.translatesAutoresizingMaskIntoConstraints = false
        let right:NSLayoutConstraint = NSLayoutConstraint(item: self, attribute: .right, relatedBy:.equal, toItem:view, attribute:.right, multiplier:1.0, constant: 0)
        let left:NSLayoutConstraint = NSLayoutConstraint(item: self, attribute: .left, relatedBy:.equal, toItem:view, attribute:.left, multiplier:1.0, constant: 0)
        view.addConstraints([right,left])
        if shouldHideTextViewBar {
            let bottom:NSLayoutConstraint = NSLayoutConstraint(item: self, attribute: .top, relatedBy:.equal, toItem:view, attribute:.bottom, multiplier:1.0, constant: 0)
            self.bottomConstraint = bottom
        }else {
            let bottom:NSLayoutConstraint = NSLayoutConstraint(item: self, attribute: .bottom, relatedBy:.equal, toItem:view, attribute:.bottom, multiplier:1.0, constant: 0)
            self.bottomConstraint = bottom
        }
        view.addConstraint(self.bottomConstraint)
    }
}

//MARK: - UITextViewDelegate & GrowingTextViewDelegate
extension TextViewBar: UITextViewDelegate, GrowingTextViewDelegate {
    
    func setButtonEnable() {
        sendButton.isEnabled = !textView.text.isEmptyField
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        setButtonEnable()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        setButtonEnable()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        if let newText = newText.cut(maxNumber: YIConstraints.messageLengthLimit, maxLine: YIConstraints.maxLine) {
            
            textView.text = newText
            textViewDidChange(textView)
            return false
        }
        return true
    }
    
    func textViewDidChangeHeight(_ textView: GrowingTextView, height: CGFloat) {
        let offset = height - textViewHeight
        self.textViewHeight = height
    }
}


