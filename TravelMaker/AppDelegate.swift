//
//  AppDelegate.swift
//  TravelMaker
//
//  Created by 이찬호 on 2023/09/08.
//

import UIKit
import NaverThirdPartyLogin
import KakaoSDKCommon
import NMapsMap
import NMapsGeometry

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        setNaverLogin()
        setKakaoLogin()
        setNaverMap()
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

//MARK: 네이버 로그인 초기화
extension AppDelegate {
    func setNaverLogin() {
        let instance = NaverThirdPartyLoginConnection.getSharedInstance()
        instance?.isNaverAppOauthEnable = true
        instance?.isInAppOauthEnable = true
        instance?.isOnlyPortraitSupportedInIphone()
        instance?.serviceUrlScheme = kServiceAppUrlScheme
        instance?.consumerKey = kConsumerKey
        instance?.consumerSecret = kConsumerSecret
        instance?.appName = kServiceAppName
    }
}

extension AppDelegate {
    func setKakaoLogin() {
        //KakaoSDK.initSDK(appKey: "5be589cc2deb0cbaf08105f0ada52f30")
        KakaoSDK.initSDK(appKey: "b4eb3fea0c7fbe33689c9458651ff344")
    }
}

extension AppDelegate {
    func setNaverMap() {
        NMFAuthManager.shared().clientId = "d339gzg0n5"
    }
}
