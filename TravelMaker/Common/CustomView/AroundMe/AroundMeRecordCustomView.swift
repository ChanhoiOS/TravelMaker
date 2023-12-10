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
        label.font = UIFont(name: "SUIT-Bold", size: 16)
        return label
    }()
    
    private let starImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "around_star_image")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let starLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.DESIGN_GREEN
        label.font = UIFont(name: "SUIT-Bold", size: 16)
        return label
    }()

    private lazy var selectBtn: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(detailInfo), for: .touchUpInside)
        return button
    }()

    init(frame: CGRect, _ detail: AroundData, _ image: UIImage) {
        super.init(frame: frame)
        setView(detail, image)
    }
    
    required init?(coder: NSCoder, _ detail: AroundData, _ image: UIImage) {
        super.init(coder: coder)
        setView(detail, image)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setView(_ detail: AroundData, _ image: UIImage) {
        self.backgroundColor = .white
        self.layer.cornerRadius = 12
        self.layer.shadowOffset = CGSize(width: 0, height: 20)
        self.layer.shadowOpacity = 0.3
        self.layer.shadowRadius = 12
        
        self.addSubview(infoImage)
        infoImage.clipsToBounds = true
        infoImage.layer.cornerRadius = 4
        infoImage.image = image
        
        infoImage.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
            make.width.height.equalTo(60)
        }
        
        categoryLabel.text = detail.categoryName ?? ""
        self.addSubview(categoryLabel)
        
        categoryLabel.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(24)
        }
        
        pageTitle.text = detail.placeName ?? ""
        self.addSubview(pageTitle)
        
        pageTitle.snp.makeConstraints { make in
            make.top.equalTo(categoryLabel.snp.bottom).offset(5)
            make.left.equalToSuperview().offset(24)
            make.right.equalTo(infoImage.snp.left).offset(-24)
        }
        
        pageContent.text = detail.address ?? ""
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
        profileImage.clipsToBounds = true
        profileImage.layer.cornerRadius = 12
        
        profileImage.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24)
            make.width.height.equalTo(31)
            make.top.equalTo(grayView.snp.bottom).offset(12)
        }
        
        self.addSubview(nameLabel)
        nameLabel.text = SessionManager.shared.nickName
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(profileImage.snp.right).offset(12)
            make.centerY.equalTo(profileImage)
        }
        
        self.addSubview(starLabel)
        var rating = Double(detail.starRating ?? 0)
        
        starLabel.text = "\(rating)"
        starLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-24)
            make.centerY.equalTo(profileImage)
        }
        
        self.addSubview(starImage)
        starImage.snp.makeConstraints { make in
            make.right.equalTo(starLabel.snp.left).offset(-2)
            make.centerY.equalTo(starLabel)
            make.height.width.equalTo(20)
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
