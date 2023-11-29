//
//  BasicButtonBuilder.swift
//  TravelMaker
//
//  Created by 이찬호 on 11/29/23.
//

import UIKit
import RxCocoa
import RxSwift
import Then

class BasicButtonBuilder {
    
    private var cornerRadius : CGFloat? = 10
    private var activeBackgroundColor: UIColor? = UIColor.init(named: "#3074F8")
    private var activeFontColor : UIColor? = UIColor.init(named: "#FFFFFF")
    
    private var disabledBackgroundColor = UIColor.init(named: "#ABB0BC")
    private var disabledFontColor = UIColor.init(named: "#FFFFFF")
    
    private var fontColor : UIColor? = UIColor.init(named: "#FFFFFF")
    private var fontSize : CGFloat? = 18
    private var fontWeight : UIFont.Weight? = .regular
    private var animationTimeInSec = 0.15
    private var frame : CGRect = CGRect.zero
    private var initialTitle : String? = ""
    private var defaultState : ButtonState = .disabled
    
    public func setCornerRadius(_ cornerRadius: CGFloat) -> BasicButtonBuilder{
        self.cornerRadius = cornerRadius
        return self
    }
    
    public func setActiveBackgroundColor(_ activeBackgroundColor: UIColor) -> BasicButtonBuilder{
        self.activeBackgroundColor = activeBackgroundColor
        return self
    }
    
    public func setActiveFontColor(_ activeFontColor: UIColor) -> BasicButtonBuilder{
        self.activeFontColor = activeFontColor
        return self
    }
    
    public func setDisabledBackgroundColor(_ disabledBackgroundColor: UIColor) -> BasicButtonBuilder {
        self.disabledBackgroundColor = disabledBackgroundColor
        return self
    }
    
    public func setDisabledFontColor(_ disabledFontColor: UIColor) -> BasicButtonBuilder {
        self.disabledFontColor = disabledFontColor
        return self
    }
    
    public func setFontColor(_ fontColor: UIColor) -> BasicButtonBuilder {
        self.fontColor = fontColor
        return self
    }
    
    public func setFontSize(_ fontSize: CGFloat) -> BasicButtonBuilder {
        self.fontSize = fontSize
        return self
    }
    
    public func setFontWeight(_ fontWeight: UIFont.Weight) -> BasicButtonBuilder {
        self.fontWeight = fontWeight
        return self
    }
    
    public func setAnimationTimeInSec(_ animationTimeInSec: CGFloat) -> BasicButtonBuilder {
        self.animationTimeInSec = animationTimeInSec
        return self
    }
    
    public func setFrame(_ frame: CGRect) -> BasicButtonBuilder {
        self.frame = frame
        return self
    }
    
    public func setInitialTitle(_ initialTitle: String?) -> BasicButtonBuilder {
        self.initialTitle = initialTitle
        return self
    }
    
    public func setDefaultStatus(_ defaultState: ButtonState) -> BasicButtonBuilder {
        self.defaultState = defaultState
        return self
    }
    
    public func build() -> BasicButton {
        return BasicButton(frame: self.frame)
            .then {
                $0.activeBackgroundColor = self.activeBackgroundColor
                $0.activeFontColor = self.fontColor
                $0.disabledBackgroundColor = self.disabledBackgroundColor
                $0.disabledFontColor = self.disabledFontColor
                $0.fontSize = self.fontSize
                $0.setTitle(self.initialTitle, for: .normal)
                $0.fontWeight = self.fontWeight
                $0.animationTimeInSec = self.animationTimeInSec
                $0.defaultState = self.defaultState
                
                if let cornerRadius = self.cornerRadius {
                    $0.layer.cornerRadius = cornerRadius
                }
            }
            .then {
                $0.configureUI()
            }
        
    }
    
    
}

enum ButtonState {
    case active
    case disabled
}

class BasicButton: UIButton {
    
    var activeBackgroundColor: UIColor? = UIColor.init(named: "#3074F8")
    var activeFontColor : UIColor? = UIColor.init(named: "#FFFFFF")
    
    var disabledBackgroundColor : UIColor? = UIColor.init(named: "#ABB0BC")
    var disabledFontColor : UIColor? = UIColor.init(named: "#FFFFFF")
    
    var fontSize : CGFloat? = 18
    var fontWeight : UIFont.Weight? = .regular
    var animationTimeInSec = 0.15
    
    var defaultState : ButtonState = .disabled
    
    private let disposeBag = DisposeBag()
    
    var onButtonTapped : (() -> ())? = nil
    
    func changeState(_ buttonState : ButtonState){
        
        UIView.animate(withDuration: self.animationTimeInSec) {
            switch buttonState {
            case .active:
                self.backgroundColor = self.activeBackgroundColor
                self.setTitleColor(self.activeFontColor, for: .normal)
            case .disabled:
                self.backgroundColor = self.disabledBackgroundColor
                self.setTitleColor(self.disabledFontColor, for: .normal)
            }
        }
        
    }
    
    func configureUI(){
        self.backgroundColor = self.defaultState == .active ? self.activeBackgroundColor : self.disabledBackgroundColor
        self.setTitleColor(self.defaultState == .active ? self.activeFontColor :
                             self.disabledFontColor, for: .normal)
        self.setTitleColor(self.defaultState == .active ? self.activeFontColor : self.disabledFontColor, for: .normal)
        
        if let fontSize = fontSize {
            self.titleLabel?.font = UIFont(name: "SUIT-Bold", size: fontSize)
        }
    }
    
    private func bindEvents(){
        self.rx.tap.bind(onNext: { [unowned self] in
            self.onButtonTapped?()
        }).disposed(by: self.disposeBag)
    }
    
    private func initialize(){
        self.configureUI()
        self.bindEvents()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialize()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.initialize()
    }
    
}

