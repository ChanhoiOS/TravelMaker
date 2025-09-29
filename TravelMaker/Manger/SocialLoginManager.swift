//
//  SocialLoginManager.swift
//  TravelMaker
//
//  Created by 이찬호 on 2023/09/13.
//

import Foundation
import Alamofire
import NidThirdPartyLogin
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
extension SocialLoginManager {
    func startNaverLogin() {
        NidOAuth.shared.requestLogin { result in
            switch result {
            case .success(let loginResult):
                let accessToken = loginResult.accessToken.tokenString
                
                self.getNaverUserInfo(accessToken)
            case .failure(let error):
                print("Error: ", error.localizedDescription)
            }
        }
    }
        
    func getNaverUserInfo(_ accessToken : String?) {
        guard let accessToken = accessToken else { return }
                
        let urlStr = "https://openapi.naver.com/v1/nid/me"
        let url = URL(string: urlStr)!
                
        let authorization = "bearer \(accessToken)"
        
        let header: HTTPHeaders = [
            "Authorization": authorization
        ]
                
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header)
            .responseDecodable(of: NaverLoginModel.self) { [weak self] response in
                switch response.result {
                case .success(let data):
                    let userId = data.response?.id ?? ""
                    
                    let id = data.response?.id ?? ""
                    
                    self?.delegate?.socialLoginSuccess(id, .naver)
                case .failure(let error):
                    self?.delegate?.socialLoginError(.naver)
                }
        }
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
