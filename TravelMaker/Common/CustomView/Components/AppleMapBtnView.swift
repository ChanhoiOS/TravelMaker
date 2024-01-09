//
//  AppleMapBtnView.swift
//  TravelMaker
//
//  Created by 이찬호 on 1/9/24.
//

import UIKit
import RxGesture
import SnapKit
import RxSwift
import RxCocoa
import Then

class AppleMapBtnView: UIView {
    
    var disposeBag = DisposeBag()
    var jumpMapFunc: (() -> Void)?
    var closeFunc: (() -> Void)?
    
    private let appleImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "apple_login")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var selectBtn: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setTitleColor(.white, for: .normal)
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView() {
        let buttonContainer = UIView()
            .then {
                self.addSubview($0)
                $0.backgroundColor = UIColor(red: 243.0/255.0, green: 243.0/255.0, blue: 243.0/255.0, alpha: 1.0)
                $0.snp.makeConstraints { make in
                    make.edges.equalToSuperview()
                }
                $0.clipsToBounds = true
                $0.layer.cornerRadius = 24
                $0.layer.borderColor = Colors.DESIGN_GRAY.cgColor
                $0.layer.borderWidth = 1
        }
        
        let appleImage = UIImageView()
            .then {
                self.addSubview($0)
                $0.image = UIImage(named: "apple_login")
                $0.snp.makeConstraints { make in
                    make.left.equalToSuperview().offset(20)
                    make.centerY.equalToSuperview()
                    make.width.height.equalTo(24)
                }
            }
        
        let apple = UILabel()
            .then {
                self.addSubview($0)
                $0.text = "apple"
                $0.textColor = Colors.DESIGN_BLACK
                $0.font = UIFont(name: "SUIT-Regular", size: 17)
                
                $0.snp.makeConstraints { make in
                    make.left.equalTo(appleImage.snp.right).offset(8)
                    make.centerY.equalToSuperview()
                }
            }
        
        let text = UILabel()
            .then {
                self.addSubview($0)
                $0.text = "map 앱 열기"
                $0.textColor = Colors.DESIGN_BLACK
                $0.font = UIFont(name: "SUIT-Bold", size: 15)
                
                $0.snp.makeConstraints { make in
                    make.left.equalTo(apple.snp.right).offset(0)
                    make.centerY.equalToSuperview()
                }
            }
        
        let closeBtn = UIButton()
            .then {
                self.addSubview($0)
                $0.setImage(UIImage(systemName: "xmark"), for: .normal)
                $0.tintColor = Colors.GRAY_LINE
                $0.snp.makeConstraints { make in
                    make.right.equalToSuperview().offset(-12)
                    make.width.height.equalTo(12)
                    make.centerY.equalToSuperview()
                }
                $0.rx.controlEvent(.touchDown)
                    .bind(onNext: { [weak self] _ in
                        if let closeFunc = self?.closeFunc {
                            closeFunc()
                        }
                    })
                    .disposed(by: disposeBag)
            }
        
        let grayView = UIView()
            .then {
                self.addSubview($0)
                $0.backgroundColor = Colors.GRAY_LINE
                $0.snp.makeConstraints { make in
                    make.right.equalTo(closeBtn.snp.left).offset(-10)
                    make.width.equalTo(1)
                    make.height.equalTo(18)
                    make.centerY.equalToSuperview()
                }
            }
        
        self.addSubview(selectBtn)
        selectBtn.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview()
            make.right.equalTo(grayView.snp.right).offset(0)
        }
        
        selectBtn.rx.controlEvent(.touchDown)
            .bind(onNext: { [weak self] _ in
                if let jumpMapFunc = self?.jumpMapFunc {
                    jumpMapFunc()
                }
            })
            .disposed(by: disposeBag)
        
    }

}

