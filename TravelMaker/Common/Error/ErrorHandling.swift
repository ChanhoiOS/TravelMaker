//
//  ErrorHandling.swift
//  TravelMaker
//
//  Created by 이찬호 on 10/31/23.
//

import Foundation

enum ErrorHandling: Error {
    case invalindUrl
    case responseError
}

extension ErrorHandling {
    public var debugDescription: String {
        switch self {
        case .invalindUrl:
            return "타당하지 않은 URL 입니다."
        case .responseError:
            return "네트워크 에러"
        }
    }
}
