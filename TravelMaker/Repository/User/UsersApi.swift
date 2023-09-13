//
//  LoginTarget.swift
//  TravelMaker
//
//  Created by 이찬호 on 2023/09/11.
//

import Foundation
import Moya

enum UsersApi {
    case login(_ socialType: String, _ loginId: String)
    case signUp(_ socialType: String, _ nickname: String, _ loginId: String)
}

extension UsersApi: TargetType {
    var baseURL: URL {
        return URL(string: Apis.baseUrl)!
    }
    
    var path: String {
        switch self {
        case .login(let socialType, _):
            return "/api/auth/login/\(socialType)"
        case .signUp(let socialType, _ , _):
            return "/api/user/signUp/\(socialType)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .login(_, _):
            return .post
        case.signUp(_, _, _):
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
        case .signUp(_, let nickname, let loginId):
            let params: [String: Any] = [
                "nickname" : nickname,
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
