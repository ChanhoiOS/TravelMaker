//
//  SetNearByBookmarkModel.swift
//  TravelMaker
//
//  Created by 이찬호 on 12/11/23.
//

import Foundation

// MARK: - SetNearByBookmarkModel
struct SetNearByBookmarkModel: Codable {
    let data: SetNearByBookmark?
    let message: String?
}

// MARK: - DataClass
struct SetNearByBookmark: Codable {
    let identifiers: [NearbyBookmarkIdentifier]?
    let generatedMaps: [NearbyBoomarkGeneratedMap]?
    let raw: NearbyBookmarkRaw?
}

// MARK: - GeneratedMap
struct NearbyBoomarkGeneratedMap: Codable {
    let nearbyBookmarkID: Int?
    let createdAt, updateAt: String?

    enum CodingKeys: String, CodingKey {
        case nearbyBookmarkID = "nearbyBookmarkId"
        case createdAt, updateAt
    }
}

// MARK: - Identifier
struct NearbyBookmarkIdentifier: Codable {
    let nearbyBookmarkID: Int?

    enum CodingKeys: String, CodingKey {
        case nearbyBookmarkID = "nearbyBookmarkId"
    }
}

// MARK: - Raw
struct NearbyBookmarkRaw: Codable {
    let fieldCount, affectedRows, insertID: Int?
    let info: String?
    let serverStatus, warningStatus, changedRows: Int?

    enum CodingKeys: String, CodingKey {
        case fieldCount, affectedRows
        case insertID = "insertId"
        case info, serverStatus, warningStatus, changedRows
    }
}

