//
//  ChatRoomViewController.swift
//  ChatRoom
//
//  Created by Wilson Hung on 2021/5/25.
//

import UIKit

class ChatRoomViewController: TextInputViewController {

    var presenter: ViewToPresenterChatProtocol?
    
    var messages: [MessageData] {
        return presenter?.messages ?? []
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "MessageOutgoingViewCell", bundle: nil), forCellReuseIdentifier: "MessageOutgoingViewCell")
        tableView.register(UINib(nibName: "MessageIncomingViewCell", bundle: nil), forCellReuseIdentifier: "MessageIncomingViewCell")
        tableView.separatorStyle = .none
        textViewBar.delegate = self
        
        let presenter = ChatMessagePresenter()
        presenter.interactor = ChatMessageInteractor()
        presenter.interactor?.presenter = presenter
        presenter.view = self
        presenter.startFetching()
        self.presenter = presenter
    }

}

extension ChatRoomViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let message = self.messages[indexPath.row]
        let isOutgoing = message.sender?.id == UserManager.shared.currentUser?.id
        
        var cell: MessageViewCell!
        
        if isOutgoing {
            cell = tableView.dequeueReusableCell(withIdentifier: "MessageOutgoingViewCell") as? MessageViewCell
        }else {
            cell = tableView.dequeueReusableCell(withIdentifier: "MessageIncomingViewCell") as? MessageViewCell
        }

        cell.displayCell(message: message, type: isOutgoing ? .outgoing : .incoming, row: indexPath.row)
        return cell

    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        self.setKey(key: self.messages[indexPath.row].id, height: cell.frame.size.height)

        if tableView.isDragging, !self.isLoading, indexPath.row == 0 {
            self.presenter?.startPaging()
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {

        return self.getHeight(key: self.messages[indexPath.row].id, defaultValue: 0)
        
    }
}

//MARK: - ItemsPresenterDelegate
extension ChatRoomViewController: PresenterToViewChatProtocol {
        
    func setLoading(bool: Bool) {
        self.isLoading = bool
    }
    
    func reloadData() {
        tableView.reloadData()
        tableView.layoutIfNeeded()
        tableView.scrollToLastRow(animated: false)
    }
    
    func showEmptySections() {
        
    }
    
    func showGettingSectionsFailed() {
        
    }

    func messageRemove(at row: Int) {
        tableView.beginUpdates()
        tableView.deleteRows(at: [IndexPath(row: row, section: 0)], with: .fade)
        tableView.endUpdates()
    }

    func messageUpdate(at row: Int) {
        self.tableView.beginUpdates()
        self.tableView.reloadRows(at: [IndexPath(row: row, section: 0)], with: .none)
        self.tableView.endUpdates()
    }
    
    func newMessageReload() {
        tableView.beginUpdates()
        tableView.insertRows(at: [IndexPath(row: messages.count - 1, section: 0)], with: .none)
        tableView.endUpdates()
        DispatchQueue.main.async {
            self.tableView.scrollToLastRow(animated: true)
        }
    }

    func pagingReload() {
        tableView.reloadDataAndKeepOffset()
    }
}
//MARK: - TextViewBarDelegate
extension ChatRoomViewController: TextViewBarDelegate {
    
    func didPressLeftButton() {

        //Note: for testing.
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.modalPresentationStyle = .fullScreen
            self.present(imagePicker, animated: true, completion: nil)
        }
//        textViewBar.imageCrop = ImageCropObject(aspect: nil, aspectRatioLockEnabled: false)
//        textViewBar.imageCrop?.showAction(self, title: nil, action: nil, completion: { [weak self] (image,error) in
//            if let pickedImage = image {
//
//                self?.uploadImage(image: pickedImage)
//
//            } else {
//                SwiftMessageObject.ErrorView(message: nil)
//            }
//        })
    }
    
    func didPressRightButton() {
        guard let text = textViewBar.textView.text, text != "" else { return }
        self.textViewBar.clearText()
        let newMessage = MessageData(body: text)
        presenter?.interactor?.sendMessage(message: newMessage)
    }
    
    func uploadImage(image: UIImage) {
        let newMessage = MessageData(image: image)
        presenter?.interactor?.sendMessage(message: newMessage)
    }
    
}

//MARK: - UIImagePickerControllerDelegate & UINavigationControllerDelegate
extension ChatRoomViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
    
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.uploadImage(image: pickedImage)

        }
        self.dismiss(animated: true, completion: nil)
    }
}
