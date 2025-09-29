//
//  JSONDecoder+Extension.swift
//  TravelMaker
//
//  Created by 이찬호 on 9/29/25.
//

import Foundation

extension JSONDecoder {
    static let iso8601WithFractionalSeconds: JSONDecoder = {
        let decoder = JSONDecoder()

        // 밀리초가 있는/없는 두 경우 모두 지원
        let isoWithMs = ISO8601DateFormatter()
        isoWithMs.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        let isoNoMs = ISO8601DateFormatter()
        isoNoMs.formatOptions = [.withInternetDateTime]

        decoder.dateDecodingStrategy = .custom { d in
            let c = try d.singleValueContainer()
            let s = try c.decode(String.self)
            if let date = isoWithMs.date(from: s) ?? isoNoMs.date(from: s) {
                return date
            }
            throw DecodingError.dataCorrupted(
                .init(codingPath: d.codingPath,
                      debugDescription: "Invalid ISO8601 date: \(s)")
            )
        }
        return decoder
    }()
}
