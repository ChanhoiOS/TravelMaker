//
//  ResponseAroundModel.swift
//  TravelMaker
//
//  Created by 이찬호 on 10/24/23.
//

import Foundation

// MARK: - ResponseAroundModel
struct ResponseAroundModel: Codable {
    let code, message: String?
    let data: [AroundData]?
    let size: Int?
}

// MARK: - Datum
struct AroundData: Codable {
    let postID: Int?
    let content: String?
    let viewCount: Int?
    let placeName: String?
    let latitude, longitude: Double?
    let dateTime, address, categoryName: String?
    let starRating: Double?
    let bookmarkStatus: BookmarkStatus?
    let imagesPath: [String]?

    enum CodingKeys: String, CodingKey {
        case postID = "postId"
        case content, viewCount, placeName, latitude, longitude, dateTime, address, categoryName, starRating, bookmarkStatus, imagesPath
    }
}

enum BookmarkStatus: String, Codable {
    case n = "N"
    case y = "Y"
}
