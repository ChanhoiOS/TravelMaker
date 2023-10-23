//
//  AroundMeCustomView.swift
//  TravelMaker
//
//  Created by 이찬호 on 2023/10/17.
//

import UIKit
import SnapKit

protocol ArroundMeCustomViewDelegate {
    func registerSpace()
    func cancelSpace()
}

class AroundMeCumtomView: UIView {
    
    var delegate: ArroundMeCustomViewDelegate?
    
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

    init(frame: CGRect, _ place: String, _ address: String) {
        super.init(frame: frame)
        setView(place, address)
    }
    
    required init?(coder: NSCoder, _ place: String, _ address: String) {
        super.init(coder: coder)
        setView(place, address)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setView(_ place: String, _ address: String) {
        self.backgroundColor = .white
        
        pageTitle.text = place
        self.addSubview(pageTitle)
        
        pageTitle.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(24)
        }
        
        pageContent.text = address
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
        delegate?.registerSpace()
    }
    
    @objc func cancelChoice() {
        delegate?.cancelSpace()
    }
}

