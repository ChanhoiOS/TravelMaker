//
//  RecommendBookmarkDeleteModel.swift
//  TravelMaker
//
//  Created by 이찬호 on 12/17/23.
//

import Foundation

// MARK: - RecommendBookmarkDeleteModel
struct RecommendBookmarkDeleteModel: Codable {
    let data: RecommendBookmarkDelete?
    let message: String?
}

// MARK: - DataClass
struct RecommendBookmarkDelete: Codable {
    let raw: [String]?
    let affected: Int?
}
