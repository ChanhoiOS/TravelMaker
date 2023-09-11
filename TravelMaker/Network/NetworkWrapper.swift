//
//  NetworkWrapper.swift
//  TravelMaker
//
//  Created by 이찬호 on 2023/09/11.
//

import Foundation
import Moya

class NetworkWrapper<Provider : TargetType> : MoyaProvider<Provider> {
    
    init(endPointClosure: @escaping EndpointClosure = MoyaProvider.defaultEndpointMapping,
         stubClosure: @escaping StubClosure = MoyaProvider.neverStub,
         plugins: [PluginType] ) {
            
        let session = MoyaProvider<Provider>.defaultAlamofireSession()
        session.sessionConfiguration.timeoutIntervalForRequest = 20
        session.sessionConfiguration.timeoutIntervalForResource = 30
        
        super.init(endpointClosure: endPointClosure, stubClosure: stubClosure, session: session, plugins: plugins)
    }
    
    func requestPost<T : Codable>(target : Provider, instance: T.Type , completion : @escaping(Result<T, MoyaError>) -> ()) {
        self.request(target) { result in
            switch result {
            case .success(let response):
                if (200..<300).contains(response.statusCode) {
                    if let decodeData = try? JSONDecoder().decode(instance, from: response.data) {
                        completion(.success(decodeData))
                    } else {
                        completion(.failure(.requestMapping("Post Moya Decoding Error")))
                    }
                } else {
                    completion(.failure(.statusCode(response)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}
