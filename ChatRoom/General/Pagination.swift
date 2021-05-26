//
//  Pagination.swift
//  ChatRoom
//
//  Created by Wilson Hung on 2021/5/25.
//

import Foundation

protocol Paginationable {
    var pagination: Pagination { get set }
}

struct Pagination {
    
    var page: Int = 1
    var perPage: Int
    
    private var total: Int = 0
    
    init(perPage: Int) {
        self.perPage = perPage
    }
    
    func isMore() -> Bool {
        return page * perPage < total
    }
    
    mutating func reset() -> Pagination {
        self.page = 1
        return self
    }
    
    mutating func next() -> Pagination {
        self.page += 1
        return self
    }
    
    mutating func updataTotal(_ total: Int) {
        self.total = total
    }
    
}
