//
//  ResponseAroundModel.swift
//  TravelMaker
//
//  Created by 이찬호 on 10/24/23.
//

import Foundation

struct ResponseAroundModel: Codable {
    let data: [AroundData]?
}

// MARK: - Datum
struct AroundData: Codable {
    let nearbyID: Int?
    let categoryName, placeName, content: String?
    let starRating: Int?
    let address, latitude, longitude: String?
    let viewCount: Int?
    let createdAt, updateAt: String?
    let user: UserInfo?
    var bookmarked: Bool?
    let imgList: [String]?

    enum CodingKeys: String, CodingKey {
        case nearbyID = "nearbyId"
        case categoryName, placeName, content, starRating, address, latitude, longitude, viewCount, createdAt, updateAt, user, bookmarked, imgList
    }
}
