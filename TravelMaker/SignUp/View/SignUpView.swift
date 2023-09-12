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
import RxSwift
import RxCocoa

class SignUpView: BaseViewController {

    let wrapper = NetworkWrapper<LoginApi>(plugins: [CustomPlugIn()])
    let disposeBag = DisposeBag()
    let flexView = UIView()
    var nickNameText = ""
    
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
        inputNickName()
        setKeyboard()
    }
    
    override func viewDidLayoutSubviews() {
        
        setButton()
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
    
    func setButton() {
        self.confirmButton.isEnabled = false
        self.confirmButton.backgroundColor = UIColor(red: 141.0/255.0, green: 141.0/255.0, blue: 141.0/255.0, alpha: 1.0)
    }
    
    func buttonAnimation(_ height: CGFloat) {
        confirmButton.flex.marginBottom(height)
        confirmButton.flex.markDirty()
        
        self.view.setNeedsLayout()
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func inputNickName() {
        nickNameTextField.rx.text
            .orEmpty
            .distinctUntilChanged()
            .subscribe(onNext: { text in
                self.nickNameText = text
                
                if text.count > 1 {
                    self.confirmButton.isEnabled = true
                    self.confirmButton.backgroundColor = UIColor(red: 56.0/255.0, green: 96.0/255.0, blue: 226.0/255.0, alpha: 1.0)
                } else {
                    self.confirmButton.isEnabled = false
                    self.confirmButton.backgroundColor = UIColor(red: 141.0/255.0, green: 141.0/255.0, blue: 141.0/255.0, alpha: 1.0)
                }
            })
            .disposed(by: disposeBag)
    }
}

extension SignUpView {
    @objc func signUpAction() {
        wrapper.requestPost(target: .signUp("kakao", "minchan", "12345"), instance: SignUpModel.self) { response in
            print("SignUp Data: ", response)
            switch response {
            case .success(let data):
                print("data: ", data)
            case .failure(let error):
                print("error: ", error)
            }
        }
    }
}


//MARK: 키보드
extension SignUpView {
    func setKeyboard() {
    keyboardHeight()
                .observe(on: MainScheduler.instance)
                .subscribe(onNext: { keyboardHeight in
                    let safeAreaBottom = self.view.pin.safeArea.bottom
                    let height = keyboardHeight > 0.0 ? (keyboardHeight - safeAreaBottom) : 0
                    self.buttonAnimation(height)
                })
                .disposed(by: disposeBag)
    }
    
    func keyboardHeight() -> Observable<CGFloat> {
        return Observable
                .from([
                    NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
                                .map { notification -> CGFloat in
                                    (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height ?? 0
                                },
                    NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
                                .map { _ -> CGFloat in
                                    0
                                }
                ])
                .merge()
    }
}
