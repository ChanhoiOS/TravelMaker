//
//  RecommendBookmarkCollectionModel.swift
//  TravelMaker
//
//  Created by 이찬호 on 12/17/23.
//

import Foundation

// MARK: - RecommendBookmarkCollectionModel
struct RecommendBookmarkCollectionModel: Codable {
    let data: [RecommendBookmarkCollection]?
}

// MARK: - Datum
struct RecommendBookmarkCollection: Codable {
    let recommendBookmarkID, userID: Int?
    let createdAt, updateAt: String?
    let recommend: RecommendCollection?

    enum CodingKeys: String, CodingKey {
        case recommendBookmarkID = "recommendBookmarkId"
        case userID = "userId"
        case createdAt, updateAt, recommend
    }
}

// MARK: - Recommend
struct RecommendCollection: Codable {
    let recommendID: Int?
    let category, categoryName, placeName: String?
    let starRating: Int?
    let address, latitude, longitude: String?
    let imageURL: String?
    let detailURL: String?
    let createdAt, updateAt: String?

    enum CodingKeys: String, CodingKey {
        case recommendID = "recommendId"
        case category, categoryName, placeName, starRating, address, latitude, longitude
        case imageURL = "imageUrl"
        case detailURL = "detailUrl"
        case createdAt, updateAt
    }
}

