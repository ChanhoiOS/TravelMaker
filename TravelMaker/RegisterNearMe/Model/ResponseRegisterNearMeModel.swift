//
//  ResponseRegisterNearMeModel.swift
//  TravelMaker
//
//  Created by 이찬호 on 10/23/23.
//

import Foundation

struct ResponseRegisterNearMeModel: Codable {
    let code, message: String?
    let data: ResponseNearMeData?
    let size: Int?
}

// MARK: - DataClass
struct ResponseNearMeData: Codable {
    let postID: Int?
    let content: String?
    let viewCount: Int?
    let placeName: String?
    let latitude, longitude: Double?
    let dateTime, address, categoryName: String?
    let starRating: Double?
    let bookmarkStatus: String?
    let imagesPath: [String]?

    enum CodingKeys: String, CodingKey {
        case postID = "postId"
        case content, viewCount, placeName, latitude, longitude, dateTime, address, categoryName, starRating, bookmarkStatus, imagesPath
    }
}
