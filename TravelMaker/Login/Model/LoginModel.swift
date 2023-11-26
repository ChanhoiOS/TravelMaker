//
//  LoginModel.swift
//  TravelMaker
//
//  Created by 이찬호 on 2023/09/11.
//

import Foundation

// MARK: - LoginModel
struct LoginModel: Codable {
    let data: UserModel?
    let message: String?
}

// MARK: - DataClass
struct UserModel: Codable {
    let accessToken: String?
    let userInfo: UserInfo?
}

// MARK: - UserInfo
struct UserInfo: Codable {
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
