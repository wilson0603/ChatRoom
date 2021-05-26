//
//  View+Extension.swift
//  ChatRoom
//
//  Created by Wilson Hung on 2021/5/25.
//

import UIKit
import SnapKit

extension UIView {
    func addTopLine(offset:CGFloat = 0, color:UIColor = UIColor.black.withAlphaComponent(0.3)) {
        let line = UIView()
        self.addSubview(line)
        line.backgroundColor = color
        line.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(offset)
            make.right.equalToSuperview().offset(-offset)
            make.height.equalTo(1/UIScreen.main.scale)
            make.top.equalToSuperview()
        }
    }
}
