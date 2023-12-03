//
//  SessionManager.swift
//  TravelMaker
//
//  Created by 이찬호 on 2023/09/11.
//

import Foundation

class SessionManager {
    
    static let shared = SessionManager()
        
    var accessToken: String? = ""
    var loginType: String = ""
    var loginId: String = ""
    var nickName: String = ""
    var profileUrl: String = ""
    
}
