//
//  String+Extension.swift
//  ChatRoom
//
//  Created by Wilson Hung on 2021/5/25.
//

import Foundation

extension String {
    var isEmptyField: Bool {
        return trimmingCharacters(in: .whitespacesAndNewlines) == ""
    }
}

extension String {
    func cut(maxNumber: Int, maxLine: Int = 1) -> String? {
        
        var editText: String?
        if count > maxNumber {
            editText = substring(to: maxNumber)
        }
        let lines = (editText ?? self).components(separatedBy: CharacterSet.newlines)
      
        if lines.count > maxLine {
            editText = lines.prefix(maxLine).joined(separator: "\n")
        }
        return editText
    }
}

extension String {
    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }
    func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return String(self[fromIndex...])
    }

    func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return String(self[..<toIndex])
    }
}
