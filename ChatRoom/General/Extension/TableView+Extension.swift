//
//  TableView+Extension.swift
//  ChatRoom
//
//  Created by Wilson Hung on 2021/5/25.
//

import UIKit

extension UITableView {
    
    func isRowVisible(indexPath: IndexPath) -> Bool {
        if let indexPathsForVisibleRows = indexPathsForVisibleRows {
            return indexPathsForVisibleRows.contains(indexPath)
        }
        return false
    }
    
    func isLastRowVisible(count: Int, section: Int = 0, inset: CGFloat) -> Bool {
        
        guard count > 2 else { return false }
        
        let previousIndexIndexPath = IndexPath(row: count - 3, section: section)

        let visibleBounds = CGRect(x: bounds.origin.x, y: bounds.origin.y, width: bounds.width, height: bounds.height - inset)
        let cellRect = rectForRow(at: previousIndexIndexPath)
        let completelyVisible = visibleBounds.contains(cellRect)
      
        return completelyVisible
    }

    func scrollToRow(row: Int, section: Int = 0, at: UITableView.ScrollPosition = .bottom, animated: Bool = true) {
        if self.numberOfSections > section && numberOfRows(inSection: section) > row {
            self.scrollToRow(at: IndexPath(row: row, section: section), at: at, animated: animated)
        }
    }
    
    func scrollToFirstRow(section: Int = 0, animated: Bool = true) {
        if self.numberOfSections > section && numberOfRows(inSection: section) > 0 {
            self.scrollToRow(at: IndexPath(row: 0, section: section), at: .bottom, animated: animated)
        }
    }
    
    func scrollToLastRow(section: Int = 0, animated: Bool = true) {
        if self.numberOfSections > section && numberOfRows(inSection: section) > 0 {
            
            let rows = numberOfRows(inSection: section)
            self.scrollToRow(at: IndexPath(row: rows - 1, section: section), at: .bottom, animated: animated)
        }
    }
    
    func reloadSection(section: Int, with: UITableView.RowAnimation = .automatic) {
        
        var indexPaths = [IndexPath]()
        for row in 0 ..< numberOfRows(inSection: section) {
            indexPaths.append(IndexPath(row: row, section: section))
        }
        reloadRows(at: indexPaths, with: with)
    }
    
    func reloadDataAndKeepOffset() {
        
        setContentOffset(contentOffset, animated: false)
        
        let previousContentHeight = contentSize.height
        let previousContentOffset = contentOffset.y

       
        reloadData()
        layoutIfNeeded()
        
        let currentContentOffset = contentSize.height - previousContentHeight + previousContentOffset
            
        contentOffset = CGPoint(x: 0, y: currentContentOffset - YIConstraints.loadingHeight)

    }
}
