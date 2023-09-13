//
//  SocialLoginManager.swift
//  TravelMaker
//
//  Created by 이찬호 on 2023/09/13.
//

import Foundation
import NaverThirdPartyLogin
import Alamofire

protocol SocialLoginDelegate {
    func socialLoginSuccess(_ social_id: String, _ type: LoginType)
    func SocialLoginError(_ type: LoginType)
}

enum LoginType {
    case apple
    case kakao
    case naver
}

class SocialLoginManager: NSObject {
    
    static let shared = SocialLoginManager()
    var delegate: SocialLoginDelegate?
    
}

extension SocialLoginManager: NaverThirdPartyLoginConnectionDelegate {
    func startNaverLogin() {
        guard let loginInstance = NaverThirdPartyLoginConnection.getSharedInstance() else { return }
                
        //이미 로그인되어있는 경우
        if loginInstance.isValidAccessTokenExpireTimeNow() {
            self.getNaverUserInfo(loginInstance.tokenType, loginInstance.accessToken)
            return
        }
                
        loginInstance.delegate = self
        loginInstance.requestThirdPartyLogin()
    }
        
    func getNaverUserInfo( _ tokenType : String?, _ accessToken : String?) {
                
        guard let tokenType = tokenType else { return }
        guard let accessToken = accessToken else { return }
                
        let urlStr = "https://openapi.naver.com/v1/nid/me"
        let url = URL(string: urlStr)!
                
        let authorization = "\(tokenType) \(accessToken)"
                
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["Authorization": authorization])
            .responseDecodable(of: NaverLoginModel.self) { [weak self] response in
                switch response.result {
                case .success(let data):
                    let id = data.response?.id ?? ""
                    
                    self?.delegate?.socialLoginSuccess(id, .naver)
                case .failure(let error):
                    self?.delegate?.SocialLoginError(.naver)
                }
        }
    }
    
    func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
        print("토큰 요청 완료")
    }
        
    func oauth20ConnectionDidFinishDeleteToken() {
        print("네이버 로그인 토큰이 삭제되었습니다.")
    }
        
    func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
        print("error: ",error)
    }
        
    func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
        guard let loginInstance = NaverThirdPartyLoginConnection.getSharedInstance() else { return }
               
        self.getNaverUserInfo(loginInstance.tokenType, loginInstance.accessToken)
    }
}
