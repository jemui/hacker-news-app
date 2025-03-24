//
//  PostData.swift
//  HackerNewsApp
//
//  Created by Jeanette on 2/10/25.
//

import Foundation

struct Post: Decodable, Identifiable, Equatable {
    let id: Int
    let by: String
    let descendants: Int
    let kids: [Int]
    let score: Int
    let time: Int
    let title: String
    let type: String
    let url: String?
}
