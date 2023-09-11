//
//  CustomPlugin.swift
//  TravelMaker
//
//  Created by 이찬호 on 2023/09/11.
//

import Foundation
import Moya

class CustomPlugIn : PluginType {
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        return request
    }
    
    func process(_ result: Result<Response, MoyaError>, target: TargetType) -> Result<Response, MoyaError> {
        return result
    }
}
