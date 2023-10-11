//
//  Utils.swift
//  TravelMaker
//
//  Created by 이찬호 on 2023/10/11.
//

import Foundation

class Utils {
    static func parsingDate(_ dateString: String) -> String {
        let endIndex = dateString.index(dateString.startIndex, offsetBy: 10)
        let truncatedString = dateString[..<endIndex]
        
        return String(truncatedString)
    }
    
    
}
