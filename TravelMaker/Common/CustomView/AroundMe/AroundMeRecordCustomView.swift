//
//  AroundMeRecordCustomView.swift
//  TravelMaker
//
//  Created by 이찬호 on 10/25/23.
//

import UIKit
import Then
import SnapKit

class AroundMeRecordCumtomView: UIView {
    
    var grayView: UIView!
    
    private let categoryLabel: PaddingLabel = {
        let label = PaddingLabel()
        label.textColor = Colors.DESIGN_BLUE
        label.font = UIFont(name: "SUIT-Regular", size: 12)
        label.layer.cornerRadius = 12
        label.layer.borderWidth = 1
        label.layer.borderColor = Colors.DESIGN_BLUE.cgColor
        return label
    }()
    
    private let pageTitle: UILabel = {
        let label = UILabel()
        label.textColor = Colors.DESIGN_BLACK
        label.font = UIFont(name: "SUIT-Bold", size: 22)
        return label
    }()
    
    private let pageContent: UILabel = {
        let label = UILabel()
        label.textColor = Colors.DESIGN_BLACK
        label.font = UIFont(name: "SUIT-Regular", size: 14)
        return label
    }()
    
    private let infoImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "around_profile")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.DESIGN_BLUE
        label.font = UIFont(name: "SUIT-Regular", size: 16)
        return label
    }()
    
    private let starLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.DESIGN_BLUE
        label.font = UIFont(name: "SUIT-Regular", size: 16)
        return label
    }()

    private lazy var selectBtn: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(detailInfo), for: .touchUpInside)
        return button
    }()

    init(frame: CGRect, _ place: String, _ address: String, _ category: String, _ image: UIImage) {
        super.init(frame: frame)
        setView(place, address, category, image)
    }
    
    required init?(coder: NSCoder,_ place: String, _ address: String, _ category: String, _ image: UIImage) {
        super.init(coder: coder)
        setView(place, address, category, image)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setView(_ place: String, _ address: String, _ category: String, _ image: UIImage) {
        self.backgroundColor = .white
        
        self.addSubview(infoImage)
        infoImage.image = image
        
        infoImage.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
            make.width.height.equalTo(60)
        }
        
        categoryLabel.text = category
        self.addSubview(categoryLabel)
        
        categoryLabel.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(24)
        }
        
        pageTitle.text = place
        self.addSubview(pageTitle)
        
        pageTitle.snp.makeConstraints { make in
            make.top.equalTo(categoryLabel.snp.bottom).offset(5)
            make.left.equalToSuperview().offset(24)
            make.right.equalTo(infoImage.snp.left).offset(-24)
        }
        
        pageContent.text = address
        self.addSubview(pageContent)
        
        pageContent.snp.makeConstraints { make in
            make.top.equalTo(pageTitle.snp.bottom).offset(8)
            make.left.equalToSuperview().offset(24)
            make.right.equalTo(infoImage.snp.left).offset(-24)
        }
        
        grayView = UIView()
            .then {
                self.addSubview($0)
                
                $0.snp.makeConstraints { make in
                    make.height.equalTo(1)
                    make.left.equalToSuperview().offset(24)
                    make.right.equalToSuperview().offset(-24)
                    make.top.equalTo(pageContent.snp.bottom).offset(12)
            }
        }
        
        self.addSubview(profileImage)
        
        profileImage.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24)
            make.width.height.equalTo(31)
            make.top.equalTo(grayView.snp.bottom).offset(12)
        }
        
        self.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(profileImage.snp.right).offset(12)
            make.centerY.equalTo(profileImage)
        }
        
        self.addSubview(starLabel)
        starLabel.text = "★ 4.0"
        starLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-24)
            make.centerY.equalTo(profileImage)
        }
        
        self.addSubview(selectBtn)
        selectBtn.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension AroundMeRecordCumtomView {
    @objc func detailInfo() {
        print("호호호")
    }
}
