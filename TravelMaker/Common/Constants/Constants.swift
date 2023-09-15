//
//  Constants.swift
//  TravelMaker
//
//  Created by 이찬호 on 2023/09/15.
//

import Foundation

struct Constants {
    static let imageUrl = "http://43.200.32.96:8140/images/"
}

public enum TMError: Error {
    case authenricationError
    case parsingError
    case timeout
    case loadImageError
    
    public var debugDescription: String {
        switch self {
        case .authenricationError:
            return "인증 에러 발생"
        case .timeout:
            return "타임아웃"
        case .parsingError:
            return "파싱 에러 발생"
        case .loadImageError:
            return "이미지 로드 에러 발생"
        }
    }
}
