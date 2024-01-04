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

    let wrapper = NetworkWrapper<UsersApi>(plugins: [CustomPlugIn()])
    let disposeBag = DisposeBag()
    let flexView = UIView()
    var nickNameText = ""
    
    var loginId = ""
    var loginType = ""
    
    private let nickNameTitle: UILabel = {
        let label = UILabel()
        label.text = "닉네임을 \n입력해 주세요."
        label.textColor = Colors.DESIGN_BLACK
        label.font = UIFont(name: "SUIT-Bold", size: 24)
        label.numberOfLines = 0
        return label
    }()
    
    private let nickNameTextField: UITextField = {
        let textField = UITextField()
        textField.textColor = Colors.DESIGN_BLACK
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
        button.backgroundColor = Colors.DESIGN_GRAY
        button.frame.size.height = 69
        button.addTarget(self, action: #selector(checkNickName), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setFlexView()
        inputNickName()
        setKeyboard()
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
                    self.confirmButton.backgroundColor = Colors.DESIGN_BLUE
                } else {
                    self.confirmButton.isEnabled = false
                    self.confirmButton.backgroundColor = Colors.DESIGN_GRAY
                }
            })
            .disposed(by: disposeBag)
    }
}

extension SignUpView {
    func signUp() {
        guard let topVC = UIApplication.topMostController() else { return }
        
        wrapper.requestPost(target: .signUp(loginType, nickNameText, loginId), instance: SignUpModel.self) { response in
            switch response {
            case .success(let data):
                print("회원가입 Data: ", data)
                Utils.completionShowAlert(title: "회원가입이 완료되었습니다. 다시 로그인을 시도해주세요.", message: "", topViewController: topVC) {
                    self.dismiss(animated: true)
                }
            case .failure(let error):
                print("회원가입 Error: ", error)
                Utils.completionShowAlert(title: "회원가입에 실패하였습니다. 관리자에게 문의해주세요.", message: "", topViewController: topVC) {
                    self.dismiss(animated: true)
                }
            }
        }
    }
    
    @objc func checkNickName() {
        guard let topVC = UIApplication.topMostController() else { return }
        
        wrapper.requestPost(target: .checkNickName(nickNameText), instance: CheckNickNameModel.self) { response in
            switch response {
            case .success(let data):
                print("닉네임 Data: ", data)
                self.signUp()
            case .failure(let error):
              print("닉네임 Error: ", error)
                Utils.completionShowAlert(title: "이미 존재하는 아이디입니다.", message: "", topViewController: topVC) {
                    
                }
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
