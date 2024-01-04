//
//  UserDefaultManager.swift
//  TravelMaker
//
//  Created by 이찬호 on 2023/09/12.
//

import Foundation

class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    
    private let defaults: UserDefaults
    
    private init() {
        defaults = UserDefaults.standard
    }
    
    var showOnboarding: Bool {
        get {
            return defaults.bool(forKey: "showOnboarding")
        }
        set {
            defaults.set(newValue, forKey: "showOnboarding")
        }
    }
    
    var profileCache: String {
        get {
            return defaults.string(forKey: "profileCache") ?? ""
        }
        set {
            defaults.set(newValue, forKey: "profileCache")
        }
    }
    
    var loginID: String {
        get {
            return defaults.string(forKey: "loginID") ?? ""
        }
        set {
            defaults.set(newValue, forKey: "loginID")
        }
    }
    
    var loginType: String {
        get {
            return defaults.string(forKey: "loginType") ?? ""
        }
        set {
            defaults.set(newValue, forKey: "loginType")
        }
    }
}
