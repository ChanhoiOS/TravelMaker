//
//  MySpaceBookmarkCollectionModel.swift
//  TravelMaker
//
//  Created by 이찬호 on 1/3/24.
//

import Foundation

// MARK: - MySpaceBookmarkCollectionModel
struct MySpaceBookmarkCollectionModel: Codable {
    let data: [MySpaceBookmarkCollection]?
}

// MARK: - MySpaceBookmarkCollection
struct MySpaceBookmarkCollection: Codable {
    let nearbyBookmarkID, userID: Int?
    let createdAt, updateAt: String?
    let nearby: MySpaceBookmarkNearby?

    enum CodingKeys: String, CodingKey {
        case nearbyBookmarkID = "nearbyBookmarkId"
        case userID = "userId"
        case createdAt, updateAt, nearby
    }
}

// MARK: - MySpaceBookmarkNearby
struct MySpaceBookmarkNearby: Codable {
    let nearbyID: Int?
    let categoryName, placeName, content: String?
    let starRating: Int?
    let address, latitude, longitude: String?
    let viewCount: Int?
    let createdAt, updateAt: String?
    let user: UserInfo?
    let imgList: [String]?

    enum CodingKeys: String, CodingKey {
        case nearbyID = "nearbyId"
        case categoryName, placeName, content, starRating, address, latitude, longitude, viewCount, createdAt, updateAt, user, imgList
    }
}

