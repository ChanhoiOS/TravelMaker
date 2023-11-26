//
//  ResponseRegisterNearMeModel.swift
//  TravelMaker
//
//  Created by 이찬호 on 10/23/23.
//

import Foundation

struct ResponseRegisterNearMeModel: Codable {
    let data: ResponseNearMeData?
}

// MARK: - DataClass
struct ResponseNearMeData: Codable {
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
