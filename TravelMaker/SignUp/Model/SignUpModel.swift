//
//  SignUpModel.swift
//  TravelMaker
//
//  Created by 이찬호 on 2023/09/12.
//

import Foundation

// MARK: - SignUpModel
struct SignUpModel: Codable {
    let data: SignUpData?
}

// MARK: - DataClass
struct SignUpData: Codable {
    let loginID, loginType, nickName: String?
    let imageURL: String?
    let userID: Int?
    let createdAt, updateAt: String?

    enum CodingKeys: String, CodingKey {
        case loginID = "loginId"
        case loginType, nickName
        case imageURL = "imageUrl"
        case userID = "userId"
        case createdAt, updateAt
    }
}

// MARK: - NickName Check
struct CheckNickNameModel: Codable {
    let message: String?
}
