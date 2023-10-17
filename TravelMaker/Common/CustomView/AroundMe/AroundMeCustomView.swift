//
//  AroundMeCustomView.swift
//  TravelMaker
//
//  Created by 이찬호 on 2023/10/17.
//

import UIKit
import SnapKit

class AroundMeCumtomView: UIView {
    
    private let pageTitle: UILabel = {
        let label = UILabel()
        label.textColor = Colors.DESIGN_BLACK
        label.font = UIFont(name: "SUIT-Bold", size: 24)
        return label
    }()
    
    private let pageContent: UILabel = {
        let label = UILabel()
        label.textColor = Colors.DESIGN_BLACK
        label.font = UIFont(name: "SUIT-Regular", size: 14)
        return label
    }()
    
    private lazy var selectBtn: UIButton = {
        let button = UIButton()
        button.backgroundColor = Colors.DESIGN_BLUE
        button.setTitle("장소선택", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "SUIT-Regular", size: 16)
        button.addTarget(self, action: #selector(selectSpace), for: .touchUpInside)
        return button
    }()
    
    private lazy var cancelBtn: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.layer.borderColor = Colors.DESIGN_GRAY.cgColor
        button.layer.borderWidth = 1
        button.setTitle("취소", for: .normal)
        button.setTitleColor(Colors.DESIGN_GRAY, for: .normal)
        button.titleLabel?.font = UIFont(name: "SUIT-Regular", size: 16)
        button.addTarget(self, action: #selector(cancelChoice), for: .touchUpInside)
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setView()
    }
    
    private func setView() {
        self.backgroundColor = .white
        
        pageTitle.text = "창경궁"
        self.addSubview(pageTitle)
        
        pageTitle.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(24)
        }
        
        pageContent.text = "서울특별시 강서구 마곡동로 62"
        self.addSubview(pageContent)
        
        pageContent.snp.makeConstraints { make in
            make.top.equalTo(pageTitle.snp.bottom).offset(6)
            make.left.equalToSuperview().offset(24)
        }
        
        self.addSubview(cancelBtn)
        cancelBtn.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-24)
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
            make.height.equalTo(50)
        }
        
        self.addSubview(selectBtn)
        selectBtn.snp.makeConstraints { make in
            make.bottom.equalTo(cancelBtn.snp.top).offset(-10)
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
            make.height.equalTo(50)
        }
        
    }
    
    @objc func selectSpace() {
        print("selectSpace")
    }
    
    @objc func cancelChoice() {
        print("cancelChoice")
    }
}

