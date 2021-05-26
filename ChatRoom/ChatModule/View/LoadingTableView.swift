//
//  LoadingTableView.swift
//  ChatRoom
//
//  Created by Wilson Hung on 2021/5/25.
//

import UIKit
import SnapKit

class LoadingTableView: UITableView {

    var loadingView: UIActivityIndicatorView?
    var cellHeightsDictionary: [IndexPath: CGFloat] = [:]
    var isLoading = false {
        didSet {
            if isLoading {
                self.tableHeaderView = loadingView
                self.loadingView?.startAnimating()
            }else {
                self.tableHeaderView = nil
                self.loadingView?.stopAnimating()
            }
        }
    }

    init(style: UITableView.Style = .plain) {
        super.init(frame: .zero, style: style)
        settings()
    }
    
    init(view: UIView, style: UITableView.Style = .plain) {
        super.init(frame: .zero, style: style)
        settings()

        view.addSubview(self)
        self.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalToSuperview()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        settings()
    }
    
    func settings() {
        self.loadingView = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 0, height: YIConstraints.loadingHeight))
        self.loadingView?.hidesWhenStopped = true
        self.loadingView?.color = .black
        self.estimatedRowHeight = 44
        self.backgroundColor = .white
        self.rowHeight = UITableView.automaticDimension
    }
    
}

