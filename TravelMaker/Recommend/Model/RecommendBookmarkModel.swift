//
//  RecommendBookmarkModel.swift
//  TravelMaker
//
//  Created by 이찬호 on 12/17/23.
//

import Foundation

// MARK: - RecommendBookmarkModel
struct RecommendBookmarkAddModel: Codable {
    let data: RecommendBookmarkAdd?
    let message: String?
}

// MARK: - DataClass
struct RecommendBookmarkAdd: Codable {
    let identifiers: [RecommendBookmarkAddIdentifier]?
    let generatedMaps: [RecommendBookmarkAddGeneratedMap]?
    let raw: RecommendBookmarkAddRaw?
}

// MARK: - GeneratedMap
struct RecommendBookmarkAddGeneratedMap: Codable {
    let recommendBookmarkID: Int?
    let createdAt, updateAt: String?

    enum CodingKeys: String, CodingKey {
        case recommendBookmarkID = "recommendBookmarkId"
        case createdAt, updateAt
    }
}

// MARK: - Identifier
struct RecommendBookmarkAddIdentifier: Codable {
    let recommendBookmarkID: Int?

    enum CodingKeys: String, CodingKey {
        case recommendBookmarkID = "recommendBookmarkId"
    }
}

// MARK: - Raw
struct RecommendBookmarkAddRaw: Codable {
    let fieldCount, affectedRows, insertID: Int?
    let info: String?
    let serverStatus, warningStatus, changedRows: Int?

    enum CodingKeys: String, CodingKey {
        case fieldCount, affectedRows
        case insertID = "insertId"
        case info, serverStatus, warningStatus, changedRows
    }
}
