//
//  VisitedLinks.swift
//  HackerNewsApp
//
//  Created by Jean on 3/24/25.
//

@MainActor
class VisitedLinks {
    static let shared = VisitedLinks()
    var links: [Int] = []
    
    private init() {}
    
}
