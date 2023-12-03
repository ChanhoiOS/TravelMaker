//
//  AsyncNetworkManager.swift
//  TravelMaker
//
//  Created by 이찬호 on 10/31/23.
//

import Foundation
import Alamofire

class AsyncNetworkManager {
    
    static var shared = AsyncNetworkManager()
    
    func commonHeaders() -> HTTPHeaders {
        var headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        
        if let accessToken = SessionManager.shared.accessToken {
            headers = ["Authorization": "Bearer " + accessToken]
        }
        
        return headers
    }
    
    func asyncGet(_ url: String) async throws -> ResponseRecommendALLModel {
        guard let url = URL(string: url) else {
            throw ErrorHandling.invalindUrl
        }
        
        let request = try URLRequest(url: url, method: .get, headers: commonHeaders())

        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw ErrorHandling.responseError
        }
        
        let asyncResult = try JSONDecoder().decode(ResponseRecommendALLModel.self, from: data)

        return asyncResult
    }
}
