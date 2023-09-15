//
//  MyPageView.swift
//  TravelMaker
//
//  Created by 이찬호 on 2023/09/13.
//

import UIKit
import Moya
import PinLayout
import FlexLayout

class MyPageView: UIViewController {
    
    let wrapper = NetworkWrapper<UsersApi>(plugins: [CustomPlugIn()])
    
    let flexView = UIView()
    
    private let backBtn: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "header_back_btn.png")
        return imageView
    }()
    
    private let pageTitle: UILabel = {
        let label = UILabel()
        label.text = "마이페이지"
        label.textColor = Colors.DESIGN_BLACK
        label.font = UIFont(name: "SUIT-Bold", size: 20)
        return label
    }()
    
    private let profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "empty_profile")
        return imageView
    }()
    
    private let nickName: UILabel = {
        let label = UILabel()
        label.text = "여행가"
        label.textColor = Colors.PRIMARY_BLACK
        label.font = UIFont(name: "SUIT-Bold", size: 20)
        return label
    }()
    
    private let address: UILabel = {
        let label = UILabel()
        label.text = "서울시 서대문구"
        label.textColor = Colors.DESIGN_GRAY
        label.font = UIFont(name: "SUIT-Regular", size: 14)
        return label
    }()
    
    private lazy var editButton: UIButton = {
        let button = UIButton()
        button.setTitle("프로필관리", for: .normal)
        button.setTitleColor(Colors.DESIGN_BLUE, for: .normal)
        button.titleLabel?.font = UIFont(name: "SUIT-Regular", size: 14)
        button.addTarget(self, action: #selector(editProfile), for: .touchUpInside)
        return button
    }()
    
    private let myPostsLabel_1: UILabel = {
        let label = UILabel()
        label.text = "내가 작성한 글"
        label.textColor = Colors.DESIGN_BLACK
        label.font = UIFont(name: "SUIT-Regular", size: 18)
        return label
    }()
    
    private let myPostsLabel_2: UILabel = {
        let label = UILabel()
        label.text = "내가 작성한 글"
        label.textColor = Colors.DESIGN_BLACK
        label.font = UIFont(name: "SUIT-Regular", size: 18)
        return label
    }()
    
    private let myPostsLabel_3: UILabel = {
        let label = UILabel()
        label.text = "내가 작성한 글"
        label.textColor = Colors.DESIGN_BLACK
        label.font = UIFont(name: "SUIT-Regular", size: 18)
        return label
    }()
    
    private lazy var myPostsButton_1: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "myPost_go_btn"), for: .normal)
        button.addTarget(self, action: #selector(goMyPosts), for: .touchUpInside)
        return button
    }()
    
    private lazy var myPostsButton_2: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "myPost_go_btn"), for: .normal)
        button.addTarget(self, action: #selector(goMyPosts), for: .touchUpInside)
        return button
    }()
    
    private lazy var myPostsButton_3: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "myPost_go_btn"), for: .normal)
        button.addTarget(self, action: #selector(goMyPosts), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setFlexView()
        fetchUserData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        flexView.pin.all(view.pin.safeArea)
        flexView.flex.layout()
    }
    
    func setFlexView() {
        view.addSubview(flexView)
        
        flexView.flex.backgroundColor(Colors.DESIGN_MYPAGE_BACKGROUND).define { flex in
            flex.addItem().height(59).direction(.row).alignItems(.center).justifyContent(.spaceBetween).define { flex in
                flex.addItem(backBtn).marginLeft(24).width(32).height(32)
                flex.addItem(pageTitle)
                flex.addItem().marginRight(24).width(32)
            }
            
            flex.addItem().height(124).direction(.row).justifyContent(.spaceBetween).define { flex in
                flex.addItem(profileImage).marginLeft(24).width(60).height(60).marginVertical(32)
                flex.addItem().paddingRight(80).define { flex in
                    flex.addItem().height(62).define { flex in
                        flex.addItem(nickName).marginTop(38)
                    }
                    flex.addItem().height(62).define { flex in
                        flex.addItem(address).marginBottom(38)
                    }
                }
                flex.addItem().define { flex in
                    flex.addItem().height(62)
                    flex.addItem().height(62).define { flex in
                        flex.addItem(editButton).marginRight(24).marginBottom(38)
                    }
                }
            }
            
            flex.addItem().height(1).backgroundColor(Colors.DESIGN_WHITE).marginHorizontal(24)
            
            flex.addItem().direction(.row).alignItems(.center).marginTop(32).height(58).marginHorizontal(24).backgroundColor(.white).define { flex in
                flex.addItem(myPostsLabel_1).position(.absolute).left(20)
                flex.addItem(myPostsButton_1).position(.absolute).right(20)
            }
            
            flex.addItem().direction(.row).alignItems(.center).marginTop(14).height(58).marginHorizontal(24).backgroundColor(.white).define { flex in
                flex.addItem(myPostsLabel_2).position(.absolute).left(20)
                flex.addItem(myPostsButton_2).position(.absolute).right(20)
            }
            
            flex.addItem().direction(.row).alignItems(.center).marginTop(14).height(58).marginHorizontal(24).backgroundColor(.white).define { flex in
                flex.addItem(myPostsLabel_3).position(.absolute).left(20)
                flex.addItem(myPostsButton_3).position(.absolute).right(20)
            }
        }
    }
}

extension MyPageView {
    @objc func editProfile() {
        
    }
    
    @objc func goMyPosts() {
        
    }
}

extension MyPageView {
    func fetchUserData() {
        wrapper.requestGet(target: .fetchMyData, instance: MyPageModel.self) { response in
            switch response {
            case .success(let data):
                print("data: ", data)
            case .failure( _):
                print("fail: ")
            }
        }
    }
}
