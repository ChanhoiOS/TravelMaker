//
//  MyRouteDeleteModel.swift
//  TravelMaker
//
//  Created by 이찬호 on 1/3/24.
//

import Foundation

// MARK: - RecommendBookmarkDeleteModel
struct MyRouteDeleteModel: Codable {
    let data: MyRouteDelete?
    let message: String?
}

// MARK: - DataClass
struct MyRouteDelete: Codable {
    let raw: [String]?
    let affected: Int?
}
