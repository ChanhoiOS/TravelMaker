//
//  MyPageModel.swift
//  TravelMaker
//
//  Created by 이찬호 on 2023/09/15.
//

import Foundation

// MARK: - MyPageModel
struct MyPageModel: Codable {
    let data: MyPageDataModel?
}

// MARK: - MyPageDataModel
struct MyPageDataModel: Codable {
    let userID: Int?
    let loginID, loginType, nickName: String?
    let imageURL: String?
    let createdAt, updateAt: String?

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case loginID = "loginId"
        case loginType, nickName
        case imageURL = "imageUrl"
        case createdAt, updateAt
    }
}
