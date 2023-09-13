//
//  SocialLoginManager.swift
//  TravelMaker
//
//  Created by 이찬호 on 2023/09/13.
//

import Foundation
import Alamofire
import NaverThirdPartyLogin
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser
import AuthenticationServices

protocol SocialLoginDelegate {
    func socialLoginSuccess(_ social_id: String, _ type: LoginType)
    func socialLoginError(_ type: LoginType)
}

enum LoginType {
    case apple
    case kakao
    case naver
}

class SocialLoginManager: NSObject {
    static let shared = SocialLoginManager()
    var delegate: SocialLoginDelegate?
    
    func startSocialLogin(_ loginType: LoginType) {
        switch loginType {
        case .apple:
            startAppleLogin()
        case .kakao:
            startKakaoLogin()
        case .naver:
            startNaverLogin()
        }
    }
}

// MARK: 카카오 로그인 로직
extension SocialLoginManager {
    func startKakaoLogin() {
            
    if UserApi.isKakaoTalkLoginAvailable() {
        UserApi.shared.loginWithKakaoTalk { oauthToken, error in
            onKakaoLoginCompleted(oauthToken?.accessToken)
        }
    } else {
        UserApi.shared.loginWithKakaoAccount(prompts:[.Login]) { oauthToken, error  in
            onKakaoLoginCompleted(oauthToken?.accessToken)
        }
    }
    
    func onKakaoLoginCompleted(_ accessToken : String?){
        getKakaoUserInfo(accessToken)
    }
    
    func getKakaoUserInfo(_ accessToken : String?) {
        UserApi.shared.me() { [weak self] user, error in
            if error == nil {
                let id = String(describing: user?.id)
                self?.delegate?.socialLoginSuccess(id, .kakao)
            } else {
                self?.delegate?.socialLoginError(.kakao)
            }
        }
    }
}
}

// MARK: 네이버 로그인 로직
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
                    self?.delegate?.socialLoginError(.naver)
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

// MARK: 애플 로그인 로직
extension SocialLoginManager: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    func startAppleLogin() {
        let appleIdProvider = ASAuthorizationAppleIDProvider()
        let request = appleIdProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        let topViewController = UIApplication.getMostTopViewController()
        return (topViewController?.view.window)!
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            let user = appleIDCredential.user
            let email = appleIDCredential.email
            
            self.delegate?.socialLoginSuccess(user, .apple)
        } else {
            self.delegate?.socialLoginError(.apple)
        }
    }
}
