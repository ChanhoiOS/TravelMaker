//
//  MyPageModel.swift
//  TravelMaker
//
//  Created by 이찬호 on 2023/09/15.
//

import Foundation

struct MyPageModel: Codable {
    let code: String?
    let message: String?
    let data: MyPageDataModel?
    let size: Int?
}

struct MyPageDataModel: Codable {
    let userId: Int?
    let loginId: String?
    let nickname: String?
    let imagePath: String?
}
