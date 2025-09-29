//
//  ResponseRecommendALLModel.swift
//  TravelMaker
//
//  Created by 이찬호 on 10/31/23.
//

import Foundation

struct ResponseRecommendALLModel: Codable {
    let data: [RecommendAllData]?
}

// MARK: - RecommendAllData
struct RecommendAllData: Codable {
    let recommendID: Int?
    let category: Category?
    let categoryName, placeName: String?
    let starRating: Int?
    let address, latitude, longitude: String?
    let imageURL: String?
    let detailURL: String?
    let createdAt, updateAt: Date?
    let bookmarked: Bool?

    enum CodingKeys: String, CodingKey {
        case recommendID = "recommendId"
        case category, categoryName, placeName, starRating, address, latitude, longitude
        case imageURL = "imageUrl"
        case detailURL = "detailUrl"
        case createdAt, updateAt, bookmarked
    }
}

enum Category: String, Codable {
    case accommodation = "ACCOMMODATION"
    case food = "FOOD"
    case popular = "POPULAR"
}
