//
//  LoginView.swift
//  TravelMaker
//
//  Created by 이찬호 on 2023/09/11.
//

import UIKit
import FlexLayout
import PinLayout

class LoginView: UIViewController {
    
    let flexView = UIView()
    
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
        label.textColor = UIColor(red: 34.0/255.0, green: 34.0/255.0, blue: 34.0/255.0, alpha: 1.0)
        label.font = UIFont(name: "SUIT-Regular", size: 14)
        return label
    }()
    
    private let kakaoTitle: UILabel = {
        let label = UILabel()
        label.text = "카카오 계정으로 시작하기"
        label.textColor = UIColor(red: 34.0/255.0, green: 34.0/255.0, blue: 34.0/255.0, alpha: 1.0)
        label.font = UIFont(name: "SUIT-Regular", size: 14)
        return label
    }()
    
    private let naverTitle: UILabel = {
        let label = UILabel()
        label.text = "네이버 계정으로 시작하기"
        label.textColor = UIColor(red: 34.0/255.0, green: 34.0/255.0, blue: 34.0/255.0, alpha: 1.0)
        label.font = UIFont(name: "SUIT-Regular", size: 14)
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setFlexView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // 2. pin으로 레이아웃 잡기
        flexView.pin.all(view.pin.safeArea)
        flexView.flex.layout()
    }
    
    func setFlexView() {
        view.addSubview(flexView)
        
        flexView.flex.paddingTop(148).alignItems(.center).define { flex in
            flex.addItem(logoImage)
                .width(168)
                .height(168)
            
            flex.addItem(appleLoginView)
                .marginTop(142)
                .width(295)
                .height(50)
                .border(1, UIColor(red: 224.0/255.0, green: 224.0/255.0, blue: 224.0/255.0, alpha: 1.0))
                .define { flex in
                    flex.addItem(appleLoginImage).position(.absolute).start(53).marginVertical(9)
                        .width(32)
                        .height(32)
                    
                    flex.addItem(appleTitle).position(.absolute).start(99).marginVertical(16)
                }
            
            flex.addItem(kakaoLoginView)
                .marginTop(12)
                .width(295)
                .height(50)
                .border(1, UIColor(red: 224.0/255.0, green: 224.0/255.0, blue: 224.0/255.0, alpha: 1.0))
                .define { flex in
                    flex.addItem(kakaoLoginImage).position(.absolute).start(53).marginVertical(9)
                        .width(32)
                        .height(32)
                    
                    flex.addItem(kakaoTitle).position(.absolute).start(99).marginVertical(16)
                }
            
            flex.addItem(naverLoginView)
                .marginTop(12)
                .width(295)
                .height(50)
                .border(1, UIColor(red: 224.0/255.0, green: 224.0/255.0, blue: 224.0/255.0, alpha: 1.0))
                .define { flex in
                    flex.addItem(naverLoginImage).position(.absolute).start(53).marginVertical(9)
                        .width(32)
                        .height(32)
                    
                    flex.addItem(naverTitle).position(.absolute).start(99).marginVertical(16)
                }
        }
    }
    
    @objc func startLogin() {
        
    }

    @IBAction func Test(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tabBarController = storyboard.instantiateViewController(withIdentifier: "TabBarViewController") as! TabBarViewController
        
        let recommendView =  RecommendView(nibName: "RecommendView", bundle: nil)
        let arroundView =  ArroundView(nibName: "ArroundView", bundle: nil)
        
        let recommentNavigationView = UINavigationController(rootViewController: recommendView)
        let arroundNavigationView = UINavigationController(rootViewController: arroundView)
        
        tabBarController.setViewControllers([recommentNavigationView, arroundNavigationView], animated: true)
        
        if let items = tabBarController.tabBar.items {
            items[0].selectedImage = UIImage(systemName: "folder.fill")
            items[0].image = UIImage(systemName: "folder")
            items[0].title = "추천"
            
            items[1].selectedImage = UIImage(systemName: "folder.fill")
            items[1].image = UIImage(systemName: "folder")
            items[1].title = "주변"
        }
         
        tabBarController.tabBar.backgroundColor = .white
        
        self.navigationController?.pushViewController(tabBarController, animated: true)
    }
    
}
