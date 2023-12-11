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
    
    func asyncGet<T: Decodable>(_ url: String,
                                _ responseModel: T.Type) async throws -> T {
        guard let url = URL(string: url) else {
            throw ErrorHandling.invalindUrl
        }
        
        let request = try URLRequest(url: url, method: .get, headers: commonHeaders())

        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw ErrorHandling.responseError
        }
        
        let asyncResult = try JSONDecoder().decode(T.self, from: data)

        return asyncResult
    }
    
    func asyncPost<T: Decodable>(_ url: String,
                                 _ paramDic: [String: Any],
                                 _ resopnseModel: T.Type) async throws -> T {
        
        var headers = [String: String]()
        
        if let accessToken = SessionManager.shared.accessToken {
            headers = [
                "Content-Type": "application/json",
                "Authorization": "Bearer " + accessToken
            ]
        } else {
            headers = [
                "Content-Type": "application/json"
            ]
        }
        
        guard let url = URL(string: url) else {
            throw ErrorHandling.invalindUrl
        }
        
        let requestBody = try JSONSerialization.data(withJSONObject: paramDic, options: [])
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        request.httpBody = requestBody

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw ErrorHandling.responseError
        }

        do {
            let asyncResult = try JSONDecoder().decode(T.self, from: data)      
            return asyncResult
        } catch {
            throw ErrorHandling.responseError
        }
    }
}

struct ResponseModel {
    var data: Any?
    var error: Error?
    var status: Int?
}

class ResponseModelBuilder {
    var data: Any?
    var error: Error?
    var status: Int?
    
    func setData(data: Any?) -> ResponseModelBuilder {
        self.data = data
        return self
    }
    
    func setError(error: Error?) -> ResponseModelBuilder {
        self.error = error
        return self
    }
    
    func setStatusCode(code: Int?) -> ResponseModelBuilder {
        self.status = code
        return self
    }
    
    func build() -> ResponseModel {
        return ResponseModel(data: self.data, error: self.error, status: status)
    }
}
