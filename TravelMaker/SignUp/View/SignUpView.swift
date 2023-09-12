//
//  SignUpView.swift
//  TravelMaker
//
//  Created by 이찬호 on 2023/09/12.
//

import UIKit
import PinLayout
import FlexLayout
import Moya

class SignUpView: UIViewController {

    //let wrapper = NetworkWrapper<LoginApi>(plugins: [CustomPlugIn()])
    
    let flexView = UIView()
    
    private let nickNameTitle: UILabel = {
        let label = UILabel()
        label.text = "닉네임을 \n입력해 주세요."
        label.textColor = UIColor(red: 34.0/255.0, green: 34.0/255.0, blue: 34.0/255.0, alpha: 1.0)
        label.font = UIFont(name: "SUIT-Bold", size: 24)
        label.numberOfLines = 0
        return label
    }()
    
    private let nickNameTextField: UITextField = {
        let textField = UITextField()
        textField.textColor = UIColor(red: 34.0/255.0, green: 34.0/255.0, blue: 34.0/255.0, alpha: 1.0)
        textField.font = UIFont(name: "SUIT-Regular", size: 18)
        textField.placeholder = "닉네임"
        textField.borderStyle = .line
        textField.layer.borderWidth = 1
        textField.layer.borderColor = CGColor(red: 141.0/255.0, green: 141.0/255.0, blue: 141.0/255.0, alpha: 1.0)
        textField.addLeftPadding()
        return textField
    }()
    
    private lazy var confirmButton: UIButton = {
        let button = UIButton()
        button.setTitle("회원가입", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "SUIT-Bold", size: 20)
        button.backgroundColor = UIColor(red: 56/255, green: 96/255, blue: 226/255, alpha: 1.0)
        button.frame.size.height = 69
        button.addTarget(self, action: #selector(signUpAction), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setFlexView()
    }
    
    override func viewDidLayoutSubviews() {
        flexView.pin.all(view.pin.safeArea)
        flexView.flex.layout()
    }
    
    func setFlexView() {
        view.addSubview(flexView)
        
        flexView.flex.direction(.column).define { flex in
            flex.addItem().define { flex in
                flex.addItem(nickNameTitle).marginTop(44).marginLeft(24)
                
                flex.addItem(nickNameTextField).height(60).marginTop(40).marginHorizontal(24)
                
            }.grow(1)
            
            flex.addItem().direction(.columnReverse).define { flex in
                flex.addItem(confirmButton).marginHorizontal(0).height(69)
            }.grow(1)
        }
        
    }
}

extension SignUpView {
    @objc func signUpAction() {
        print("버튼 탭")
    }
}
