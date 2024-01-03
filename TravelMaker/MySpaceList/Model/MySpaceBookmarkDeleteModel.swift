//
//  MySpaceBookmarkDeleteModel.swift
//  TravelMaker
//
//  Created by 이찬호 on 1/3/24.
//

import Foundation

// MARK: - RecommendBookmarkDeleteModel
struct MySpaceBookmarkDeleteModel: Codable {
    let data: MySpaceBookmarkDelete?
    let message: String?
}

// MARK: - DataClass
struct MySpaceBookmarkDelete: Codable {
    let raw: [String]?
    let affected: Int?
}
