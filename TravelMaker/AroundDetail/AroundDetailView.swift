//
//  AroundDetailView.swift
//  TravelMaker
//
//  Created by 이찬호 on 10/30/23.
//

import UIKit
import Then
import SnapKit
import ReactorKit
import RxSwift
import RxCocoa
import ImageSlideshow
import Kingfisher

class AroundDetailView: BaseViewController {
    var scrollView: UIScrollView!
    var contentView: UIView!
    var profileLine: UIView!
    var bottomLine: UIView!
    
    var imageSlide: ImageSlideshow!
    
    var detailData: AroundData?
    
    private let profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "around_profile")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let backBtn: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "detail_backBtn.png")
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.DESIGN_BLUE
        label.font = UIFont(name: "SUIT-Regular", size: 14)
        return label
    }()
    
    private let addressLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.DESIGN_GRAY
        label.font = UIFont(name: "SUIT-Regular", size: 14)
        return label
    }()
    
    private let contentTitle: UILabel = {
        let label = UILabel()
        label.textColor = Colors.DESIGN_BLACK
        label.font = UIFont(name: "SUIT-Regular", size: 26)
        return label
    }()
    
    private let contentAddress: UILabel = {
        let label = UILabel()
        label.textColor = Colors.COLLECTION_COUNT_GRAY
        label.font = UIFont(name: "SUIT-Regular", size: 16)
        return label
    }()
    
    private let contentDate: UILabel = {
        let label = UILabel()
        label.textColor = Colors.DESIGN_GRAY
        label.font = UIFont(name: "SUIT-Regular", size: 14)
        return label
    }()
    
    private let contentText: UILabel = {
        let label = UILabel()
        label.textColor = Colors.DESIGN_BLACK
        label.font = UIFont(name: "SUIT-Regular", size: 18)
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setScrollView()
        setImageSlide()
        setProfile()
        setContent()
        
        setGesture()
    }

    func setScrollView() {
        scrollView = UIScrollView()
            .then {
                self.view.addSubview($0)
                $0.translatesAutoresizingMaskIntoConstraints = false
                $0.snp.makeConstraints { make in
                    make.top.equalToSuperview().offset(44)
                    make.left.right.equalToSuperview()
                    make.bottom.equalToSuperview().offset(-69)
                }
            }
            .then {
                contentView = UIView()
                $0.addSubview(contentView)
                contentView.translatesAutoresizingMaskIntoConstraints = false
                contentView.snp.makeConstraints { make in
                    make.top.bottom.equalToSuperview()
                    make.left.right.equalTo(self.view)
                }
            }
    }
    
    func setImageSlide() {
        imageSlide = ImageSlideshow()
            .then {
                contentView.addSubview($0)
                
                $0.snp.makeConstraints { make in
                    make.top.left.right.equalToSuperview()
                    make.height.equalTo(234)
                }
            }
            .then {
                $0.contentScaleMode = .scaleAspectFill
                
                if let imagesPath = detailData?.imagesPath {
                    $0.setImageInputs(getImageInputs(imagePaths: imagesPath))
                    $0.slideshowInterval = 3
                    $0.pageIndicatorPosition = .init(horizontal: .center, vertical: .bottom)
                }
            }
        
        imageSlide.addSubview(backBtn)
        
        backBtn.snp.makeConstraints { make in
            make.left.top.equalToSuperview().offset(24)
            make.height.width.equalTo(36)
        }
        
        imageSlide.bringSubviewToFront(backBtn)
    }
    
    func setProfile() {
        contentView.addSubview(profileImage)
        profileImage.layer.cornerRadius = 18
        
        profileImage.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24)
            make.width.height.equalTo(36)
            make.top.equalTo(imageSlide.snp.bottom).offset(18)
        }
        
        contentView.addSubview(nameLabel)
        nameLabel.text = "차니"
        
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(profileImage.snp.right).offset(12)
            make.top.equalTo(imageSlide.snp.bottom).offset(21.5)
        }
        
        contentView.addSubview(addressLabel)
        addressLabel.text = detailData?.address ?? ""
        
        
        addressLabel.snp.makeConstraints { make in
            make.left.equalTo(profileImage.snp.right).offset(12)
            make.top.equalTo(nameLabel.snp.bottom).offset(6)
        }
        
        profileLine = UIView()
            .then {
                self.view.addSubview($0)
                $0.backgroundColor = Colors.GRAY_LINE
                $0.snp.makeConstraints { make in
                    make.left.right.equalToSuperview()
                    make.bottom.equalTo(profileImage.snp.bottom).offset(26)
                    make.height.equalTo(1)
                }
            }
    }
    
    func setContent() {
        contentView.addSubview(contentTitle)
        contentTitle.text = detailData?.placeName ?? ""
        
        contentTitle.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24)
            make.top.equalTo(profileLine.snp.bottom).offset(20)
        }
        
        contentView.addSubview(contentAddress)
        contentAddress.text = detailData?.address ?? ""
        
        contentAddress.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24)
            make.top.equalTo(contentTitle.snp.bottom).offset(4)
        }
        
        contentView.addSubview(contentDate)
        contentDate.text = detailData?.dateTime ?? ""
        
        contentDate.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24)
            make.top.equalTo(contentAddress.snp.bottom).offset(10)
        }
        
        contentView.addSubview(contentText)
        contentText.text = detailData?.content ?? ""
        
        contentText.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24)
            make.top.equalTo(contentDate.snp.bottom).offset(40)
        }
        
        bottomLine = UIView()
            .then {
                self.view.addSubview($0)
                $0.backgroundColor = Colors.GRAY_LINE
                $0.snp.makeConstraints { make in
                    make.left.right.equalToSuperview()
                    make.bottom.equalTo(profileImage.snp.bottom).offset(26)
                    make.height.equalTo(1)
                }
            }
    }
}

extension AroundDetailView {
    func getImageInputs(imagePaths: [String]) -> [KFSource] {
        let sources = imagePaths.map {
            KFSource(urlString: Apis.imageUrl + $0)!
        }
        print("source: ", sources)
        return sources
    }
}

extension AroundDetailView {
    func setGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backBtnAction))
        backBtn.addGestureRecognizer(tapGesture)
        backBtn.isUserInteractionEnabled = true
        
        scrollView.addGestureRecognizer(tapGesture)
    }
    
    @objc func backBtnAction(sender: UITapGestureRecognizer) {
        self.navigationController?.popViewController(animated: true)
    }
}
