//
//  LoginTarget.swift
//  TravelMaker
//
//  Created by 이찬호 on 2023/09/11.
//

import Foundation
import Moya

enum LoginApi {
    case login(_ socialType: String, _ loginId: String)
}

extension LoginApi: TargetType {
    var baseURL: URL {
        return URL(string: Apis.baseUrl)!
    }
    
    var path: String {
        switch self {
        case .login(let socialType , _):
            return "/api/auth/login/\(socialType)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .login(_, _):
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .login(_ , let loginId):
            let params: [String: Any] = [
                "loginId" : loginId
            ]
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        var header = [String: String]()
        header = [
            "Content-Type":"application/json",
        ]
        
        if let accessToken = SessionManager.shared.accessToken {
            header = ["Authorization": "Bearer \(accessToken)"]
        }
        
        return header
    }
}
