//
//  ScrollFlotyBtnView.swift
//  HealthZZang
//
//  Created by 이찬호 on 2022/08/16.
//

import UIKit
import RxGesture
import SnapKit
import RxSwift
import RxCocoa
import Then

class ScrollFlotyBtnView: UIView {
    
    var disposeBag = DisposeBag()
    var backFunc: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        initFloaty()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initFloaty() {
        let buttonContainer = UIView()
            .then {
                self.addSubview($0)
                $0.backgroundColor = UIColor(red: 243.0/255.0, green: 243.0/255.0, blue: 243.0/255.0, alpha: 1.0)
                $0.snp.makeConstraints { make in
                    make.edges.equalToSuperview()
                }
                $0.clipsToBounds = true
                $0.layer.cornerRadius = 24
        }
        
        let upImage = UIImageView()
            .then {
                self.addSubview($0)
                $0.image = UIImage(named: "ic_close.png")
                $0.snp.makeConstraints { make in
                    make.edges.equalToSuperview()
                    
                }
            }
        
        buttonContainer.rx
            .tapGesture()
            .when(.recognized)
            .bind(onNext: { [unowned self] _ in
                if let backFunc = backFunc {
                    backFunc()
                }
            })
            .disposed(by: self.disposeBag)
        
    }

}
