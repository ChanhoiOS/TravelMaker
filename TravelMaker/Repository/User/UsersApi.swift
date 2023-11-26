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
    case fetchMyData
}

extension UsersApi: TargetType {
    var baseURL: URL {
        return URL(string: Apis.baseUrl)!
    }
    
    var path: String {
        switch self {
        case .login(_ , _):
            return "/api/auth/login"
        case .signUp(_ , _ , _):
            return "/api/user/join"
        case .fetchMyData:
            return "/api/user/profile"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .login(_, _):
            return .post
        case .signUp(_, _, _):
            return .post
        case .fetchMyData:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .login(let loginType , let loginId):
            let params: [String: Any] = [
                "loginType" : loginType,
                "loginId" : loginId
            ]
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        case .signUp(let loginType, let nickname, let loginId):
            let params: [String: Any] = [
                "loginType" : loginType,
                "nickName" : nickname,
                "loginId" : loginId
            ]
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        case .fetchMyData:
            let params: [String: Any] = [:]
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        var header = [String: String]()
        header = [
            "Content-Type":"application/json",
        ]
        
        if let accessToken = SessionManager.shared.accessToken {
            header = ["Authorization": accessToken]
        }
        
        return header
    }
}
