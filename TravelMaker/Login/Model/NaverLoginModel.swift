//
//  NaverLoginModel.swift
//  TravelMaker
//
//  Created by 이찬호 on 2023/09/13.
//

import Foundation

struct NaverLoginModel: Codable {
    var resultCode: String?
    var response: NaverLoginData?
    var message: String?
    
    enum CodingKeys: String, CodingKey {
        case resultCode = "resultcode"
        case response
        case message
    }
}

struct NaverLoginData: Codable {
    var email: String?
    var id: String?
    var name: String?
}
    

