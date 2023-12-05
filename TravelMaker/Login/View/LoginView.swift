//
//  LoginView.swift
//  TravelMaker
//
//  Created by 이찬호 on 2023/09/11.
//

import UIKit
import FlexLayout
import PinLayout
import RxSwift

class LoginView: BaseViewController {
    
    var tabBarViewController: TabBarViewController?
    let wrapper = NetworkWrapper<UsersApi>(plugins: [CustomPlugIn()])
    
    let flexView = UIView()
    var disposeBag = DisposeBag()
    
    private let logoImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "main_logo")
        return imageView
    }()
    
    private let appleLoginView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let kakaoLoginView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let naverLoginView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let appleLoginImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "apple_login")
        return imageView
    }()
    
    private let kakaoLoginImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "kakao_login")
        return imageView
    }()
    
    private let naverLoginImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "naver_login")
        return imageView
    }()
    
    private let appleTitle: UILabel = {
        let label = UILabel()
        label.text = "애플 계정으로 시작하기"
        label.textColor = Colors.DESIGN_BLACK
        label.font = UIFont(name: "SUIT-Regular", size: 14)
        return label
    }()
    
    private let kakaoTitle: UILabel = {
        let label = UILabel()
        label.text = "카카오 계정으로 시작하기"
        label.textColor = Colors.DESIGN_BLACK
        label.font = UIFont(name: "SUIT-Regular", size: 14)
        return label
    }()
    
    private let naverTitle: UILabel = {
        let label = UILabel()
        label.text = "네이버 계정으로 시작하기"
        label.textColor = Colors.DESIGN_BLACK
        label.font = UIFont(name: "SUIT-Regular", size: 14)
        return label
    }()
    
    private lazy var appleLoginButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(appleLogin), for: .touchUpInside)
        return button
    }()
    
    private lazy var kakaoLoginButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(kakaoLogin), for: .touchUpInside)
        return button
    }()
    
    private lazy var naverLoginButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(naverLogin), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLocation()
        setFlexView()
        setTabBar()
        
        SocialLoginManager.shared.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        flexView.pin.all(view.pin.safeArea)
        flexView.flex.layout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        checkOnboarding()
    }
    
    func setFlexView() {
        view.addSubview(flexView)
        
        flexView.flex.alignItems(.center).define { flex in
            flex.addItem().marginTop(148).define { flex in
                flex.addItem(logoImage)
                    .width(168)
                    .height(168)
            }.grow(1)
            
            flex.addItem().define { flex in
                flex.addItem(appleLoginView)
                    .marginTop(142)
                    .width(295)
                    .height(50)
                    .border(1, Colors.DESIGN_WHITE)
                    .define { flex in
                        flex.addItem(appleLoginImage).position(.absolute).start(53).marginVertical(9)
                            .width(32)
                            .height(32)
                        
                        flex.addItem(appleTitle).position(.absolute).start(99).marginVertical(16)
                        
                        flex.addItem(appleLoginButton).position(.absolute).all(0)
                    }
                
                flex.addItem(kakaoLoginView)
                    .marginTop(12)
                    .width(295)
                    .height(50)
                    .border(1, Colors.DESIGN_WHITE)
                    .define { flex in
                        flex.addItem(kakaoLoginImage).position(.absolute).start(53).marginVertical(9)
                            .width(32)
                            .height(32)
                        
                        flex.addItem(kakaoTitle).position(.absolute).start(99).marginVertical(16)
                        
                        flex.addItem(kakaoLoginButton).position(.absolute).all(0)
                    }
                
                flex.addItem(naverLoginView)
                    .marginTop(12)
                    .width(295)
                    .height(50)
                    .border(1, Colors.DESIGN_WHITE)
                    .define { flex in
                        flex.addItem(naverLoginImage).position(.absolute).start(53).marginVertical(9)
                            .width(32)
                            .height(32)
                        
                        flex.addItem(naverTitle).position(.absolute).start(99).marginVertical(16)
                        
                        flex.addItem(naverLoginButton).position(.absolute).all(0)
                    }
            }.grow(1)
        }
    }
    
    func checkOnboarding() {
        if !UserDefaultsManager.shared.showOnboarding {
            let vc = OnboardingView(nibName: "OnboardingView", bundle: nil)
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true)
        }
    }
}

extension LoginView {
    func setTabBar() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        tabBarViewController = storyboard.instantiateViewController(withIdentifier: "TabBarViewController") as? TabBarViewController
        
        let recommendView =  RecommendView(nibName: "RecommendView", bundle: nil)
        let aroundView =  AroundView(nibName: "AroundView", bundle: nil)
        aroundView.reactor = AroundViewReactor()
        
        let registerView = RegisterNearMe(nibName: "RegisterNearMe", bundle: nil)
        
        let myCollectionView = MyCollectionView(nibName: "MyCollectionView", bundle: nil)
        let myPageView = MyPageView(nibName: "MyPageView", bundle: nil)

        let recommentNavigationView = UINavigationController(rootViewController: recommendView)
        let aroundNavigationView = UINavigationController(rootViewController: aroundView)
        let registerNavigationView = UINavigationController(rootViewController: registerView)
        let myCollectionNavigationView = UINavigationController(rootViewController: myCollectionView)
        let myPageNavigationView = UINavigationController(rootViewController: myPageView)

        recommentNavigationView.isNavigationBarHidden = true
        aroundNavigationView.isNavigationBarHidden = true
        registerNavigationView.isNavigationBarHidden = true
        myCollectionNavigationView.isNavigationBarHidden = true
        myPageNavigationView.isNavigationBarHidden = true
        
        tabBarViewController?.setViewControllers([recommentNavigationView, aroundNavigationView, BaseWhiteView(), myCollectionNavigationView, myPageNavigationView], animated: true)
        
        if let items = tabBarViewController?.tabBar.items {
            items[0].selectedImage = UIImage(named: "tabBar_selected_recommend")
            items[0].image = UIImage(named: "tabBar_recommend")
            items[0].title = "추천"

            items[1].selectedImage = UIImage(named: "tabBar_selected_arround")
            items[1].image = UIImage(named: "tabBar_arround")
            items[1].title = "내 주변"
            
            items[2].selectedImage = UIImage(named: "tabBar_register")
            items[2].image = UIImage(named: "tabBar_register")
            
            items[3].selectedImage = UIImage(named: "tabBar_selected_collection")
            items[3].image = UIImage(named: "tabBar_collection")
            items[3].title = "컬렉션"
            
            items[4].selectedImage = UIImage(named: "tabBar_selected_mypage")
            items[4].image = UIImage(named: "tabBar_mypage")
            items[4].title = "마이"
        }

        tabBarViewController?.tabBar.backgroundColor = .white

    }
}

extension LoginView: SocialLoginDelegate {
    @objc func appleLogin() {
        SocialLoginManager.shared.startSocialLogin(.apple)
    }
    
    @objc func kakaoLogin() {
        SocialLoginManager.shared.startSocialLogin(.kakao)
    }
    
    @objc func naverLogin() {
        SocialLoginManager.shared.startSocialLogin(.naver)
    }
    
    func socialLoginSuccess(_ social_id: String, _ type: LoginType) {
        switch type {
        case .apple:
            socialLogin("apple", social_id)
        case .kakao:
            socialLogin("kakao", social_id)
        case .naver:
            socialLogin("naver", social_id)
        }
    }
    
    func socialLoginError(_ type: LoginType) {
        switch type {
        case .apple:
            print("apple login error")
        case .kakao:
            print("kakao login error")
        case .naver:
            print("naver login error")
        }
    }
    
    func socialLogin(_ type: String, _ id: String) {
        wrapper.requestPost(target: .login(type, id), instance: LoginModel.self) { response in
            switch response {
            case .success(let data):
                self.goToMain(data)
            case .failure( _):
                self.goToSignUp(type, id)
            }
        }
    }
}

extension LoginView {
    func goToMain(_ data: LoginModel) {
        if let token = data.data?.accessToken {
            SessionManager.shared.accessToken = token
            print("token: ", token)
        }
        
        SessionManager.shared.nickName = data.data?.userInfo?.nickName ?? ""
        SessionManager.shared.profileUrl = data.data?.userInfo?.imageURL ?? ""
        SessionManager.shared.loginType = data.data?.userInfo?.loginType ?? ""
        SessionManager.shared.loginId = data.data?.userInfo?.loginID ?? ""
        
        self.navigationController?.pushViewController(tabBarViewController ?? TabBarViewController(), animated: true)
    }
    
    func goToSignUp(_ type: String, _ id: String) {
        let vc = SignUpView(nibName: "SignUpView", bundle: nil)
        vc.modalPresentationStyle = .overFullScreen
        vc.loginId = id
        vc.loginType = type
        self.present(vc, animated: true)
    }
}

extension LoginView {
    func setLocation() {
        LocationManager.shared.requestLocation()
            .bind { print($0) }
            .disposed(by: self.disposeBag)
    }
}

      
