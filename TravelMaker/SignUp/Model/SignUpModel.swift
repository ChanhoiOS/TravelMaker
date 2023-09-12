//
//  SignUpModel.swift
//  TravelMaker
//
//  Created by 이찬호 on 2023/09/12.
//

import Foundation

import Foundation

struct SignUpModel: Codable {
    let code: String?
    let message: String?
    let data: SignUpData?
    let size: Int?
}

struct SignUpData: Codable {
    let userId: Int?
    let loginId: String?
    let nickname: String?
}
