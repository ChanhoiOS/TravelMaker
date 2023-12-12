//
//  ResponseAroundDetailModel.swift
//  TravelMaker
//
//  Created by 이찬호 on 12/12/23.
//

import Foundation

// MARK: - DeleteNearByBookmarkModel
struct ResponseAroundDetailModel: Codable {
    let data: AroundDetailData?
}

// MARK: - DataClass
struct AroundDetailData: Codable {
    let nearbyID: Int?
    let categoryName, placeName, content: String?
    let starRating: Int?
    let address, latitude, longitude: String?
    let viewCount: Int?
    let createdAt, updateAt: String?
    let user: UserInfo?
    let bookmarked: Bool?
    let imgList: [String]?

    enum CodingKeys: String, CodingKey {
        case nearbyID = "nearbyId"
        case categoryName, placeName, content, starRating, address, latitude, longitude, viewCount, createdAt, updateAt, user, bookmarked, imgList
    }
}
