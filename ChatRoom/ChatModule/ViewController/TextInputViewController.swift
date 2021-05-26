//
//  TextInputViewController.swift
//  ChatRoom
//
//  Created by Wilson Hung on 2021/5/25.
//

import UIKit

class TextInputViewController: UIViewController {
    
    final lazy var textViewBar: TextViewBar = {
        let containerView = Bundle.main.loadNibNamed("TextViewBar", owner: self, options: nil)?.first as! TextViewBar
        return containerView
    }()
    
    var tableView: LoadingTableView!
    var isLoading: Bool = false {
        didSet {
            tableView.isLoading = isLoading
        }
    }
    //var shouldJumpOffset = false
    
    var keyboardHeight: CGFloat = 0
    private var cellKeysDictionary: [String: CGFloat] = [:]
    private var isMessagesControllerBeingDismissed: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        
        tableView = LoadingTableView(view: view)
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableView.automaticDimension
       
        NotificationCenter.default.addObserver(self,selector: #selector(self.keyboardWillChangeFrame(_:)),name: UIResponder.keyboardWillChangeFrameNotification,object: nil)

    }

    override var inputAccessoryView: UIView? {
        return textViewBar
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        isMessagesControllerBeingDismissed = false
        
        self.becomeFirstResponder()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
      
        isMessagesControllerBeingDismissed = true
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}

//MARK: - cache keys
extension TextInputViewController {
    
    func setKey(key: String?, height: CGFloat) {
        if let key = key {
           
            self.cellKeysDictionary[key] = height
        }
    }
    
    func getHeight(key: String?, defaultValue: CGFloat = UITableView.automaticDimension) -> CGFloat {
        
        if let key = key, let height = self.cellKeysDictionary[key] {
            return height
        }
        return defaultValue
    }
    
}

//MARK: - keyboard observer
private extension TextInputViewController {
    
    @objc func dismissKeyboard() {
       
        textViewBar.textView.resignFirstResponder()
    }
    
    @objc func keyboardWillChangeFrame(_ notification: Notification) {
  
        if let userInfo = notification.userInfo,
        let beginFrame = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue,
        let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {

            keyboardHeight = endFrame.height
            //shouldJumpOffset, 
            if !isMessagesControllerBeingDismissed, !isLoading, presentedViewController == nil {

                let delta = (endFrame.origin.y - beginFrame.origin.y)
                let offset = tableView.contentOffset.y - delta
                tableView.contentOffset = CGPoint(x: 0, y: offset)
                
            }
            
            tableView.contentInset.bottom = keyboardHeight - bottomLayoutGuide.length
            tableView.scrollIndicatorInsets.bottom = tableView.contentInset.bottom
          
         }
    }
}
