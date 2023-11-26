//
//  ResponseRecommendALLModel.swift
//  TravelMaker
//
//  Created by 이찬호 on 10/31/23.
//

import Foundation

struct ResponseRecommendALLModel: Codable {
    let code, message: String?
    let data: [RecommendAllData]?
    let size: Int?
}

// MARK: - Datum
struct RecommendAllData: Codable {
    let id: Int?
    let address: String?
    let latitude, longitude: Double?
    let category: Category?
    let placeName, categoryName: String?
    let starRating: Int?
    let detailURL: String?
    let imageURL: String?

    enum CodingKeys: String, CodingKey {
        case id, address, latitude, longitude, category, placeName, categoryName, starRating
        case detailURL = "detailUrl"
        case imageURL = "imageUrl"
    }
}

enum Category: String, Codable {
    case accommodation = "ACCOMMODATION"
    case food = "FOOD"
    case popular = "POPULAR"
}
