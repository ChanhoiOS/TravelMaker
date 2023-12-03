//
//  ApiManager.swift
//  TravelMaker
//
//  Created by 이찬호 on 12/3/23.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire

class ApiManager {
    
    static let shared = ApiManager()
    
    func commonHeaders() -> HTTPHeaders {
        var headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        
        if let accessToken = SessionManager.shared.accessToken {
            headers = ["Authorization": "Bearer " + accessToken]
        }
        
        return headers
    }
    
    func post(url: String,
                         paramDic: [String:Any],
                         successHandler: @escaping () -> Void,
                         failHandler: @escaping () -> Void) {
        AF.request(url, method: .post, parameters: paramDic, encoding: JSONEncoding.default, headers: self.commonHeaders())
            .validate(statusCode: 200..<500)
            .responseJSON { response in
                if response.response?.statusCode == 200 {
                    successHandler()
                } else {
                    failHandler()
                }
            }
    }
    
    func delete(url: String,
                         paramDic: [String:Any],
                         successHandler: @escaping () -> Void,
                         failHandler: @escaping () -> Void) {
        AF.request(url, method: .delete, parameters: paramDic, encoding: JSONEncoding.default, headers: self.commonHeaders())
            .validate(statusCode: 200..<500)
            .responseJSON { response in
                if response.response?.statusCode == 200 {
                    successHandler()
                } else {
                    failHandler()
                }
            }
    }
}
