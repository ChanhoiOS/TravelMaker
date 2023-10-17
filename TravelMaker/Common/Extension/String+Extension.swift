//
//  String+Extension.swift
//  TravelMaker
//
//  Created by 이찬호 on 2023/09/15.
//

import Foundation

extension String {
    func replacingSlashWithUnderscore() -> String {
        return self.replacingOccurrences(of: "/", with: "_")
    }
    
    func toDouble() -> Double? {
        return NumberFormatter().number(from: self)?.doubleValue
    }
}
