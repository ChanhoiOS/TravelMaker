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

    override func viewDidLoad() {
        super.viewDidLoad()

        setFlexView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        flexView.pin.all(view.pin.safeArea)
        flexView.flex.layout()
    }
    
    func setFlexView() {
        view.addSubview(flexView)
        
        flexView.flex.define { flex in
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
        }
    }

}

extension MyPageView {
    @objc func editProfile() {
        
    }
}
