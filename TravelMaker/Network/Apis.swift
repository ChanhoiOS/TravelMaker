//
//  Apis.swift
//  TravelMaker
//
//  Created by 이찬호 on 2023/09/11.
//

import Foundation

struct Apis {
    static let baseUrl = "http://43.200.32.96:8140"
    
    static let login = "\(Apis.baseUrl)/api/auth/login"
    
    static let postAround = "\(Apis.baseUrl)/api/post"
    
    static let getAround = "\(Apis.baseUrl)/api/post/all"
}
