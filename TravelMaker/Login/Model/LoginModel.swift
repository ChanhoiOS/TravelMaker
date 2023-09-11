//
//  LoginModel.swift
//  TravelMaker
//
//  Created by 이찬호 on 2023/09/11.
//

import Foundation

struct LoginModel: Codable {
    let code: String?
    let message: String?
    let data: TokenModel?
    let size: Int?
}

struct TokenModel: Codable {
    let accessToken: String?
}
