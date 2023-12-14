//
//  RecommendCollectionViewCell.swift
//  TravelMaker
//
//  Created by 이찬호 on 11/1/23.
//

import UIKit
import SnapKit
import Then
import Kingfisher

class RecommendCollectionViewCell: UICollectionViewCell {
    static var id: String { NSStringFromClass(Self.self).components(separatedBy: ".").last ?? "" }

    var model: RecommendAllData? {
        didSet {
            bind()
        }
    }
    
    var recommendImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "collection_recommend")
        return imageView
    }()

    lazy var placeName: UILabel = {
        let label = UILabel()
        label.textColor = Colors.DESIGN_BLACK
        label.font = UIFont(name: "SUIT-ExtraBold", size: 16)
        return label
    }()
    
    lazy var distance: UILabel = {
        let label = UILabel()
        label.textColor = Colors.RECOMMEND_GRAY
        label.font = UIFont(name: "SUIT-Regular", size: 12)
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubviews()

        configure()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }

    private func addSubviews() {
        addSubview(recommendImage)
        addSubview(placeName)
        addSubview(distance)
    }

    private func configure() {
        recommendImage.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(100)
        }
        
        placeName.snp.makeConstraints { make in
            make.top.equalTo(recommendImage.snp.bottom).offset(12)
            make.left.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-12)
        }
        
        distance.snp.makeConstraints { make in
            make.top.equalTo(placeName.snp.bottom).offset(8)
            make.left.equalToSuperview().offset(12)
        }
        
        backgroundColor = .placeholderText
    }

    private func bind() {
        if let imageURL = model?.imageURL {
            let url = URL(string: imageURL)
            recommendImage.kf.setImage(with: url)
        }
        
        placeName.text = model?.placeName ?? ""
    }

}
