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
        label.font = UIFont(name: "SUIT-Bold", size: 16)
        return label
    }()
    
    private let contentTitle: UILabel = {
        let label = UILabel()
        label.textColor = Colors.DESIGN_BLACK
        label.font = UIFont(name: "SUIT-Bold", size: 26)
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
        label.numberOfLines = 0
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
    
    private let commentImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "detail_comment")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let bookmarkImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "detail_bookmark")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setScrollView()
        setImageSlide()
        setProfile()
        setContent()
        setStar()
        
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
                
                if let imagesPath = detailData?.imgList {
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
            make.width.height.equalTo(31)
            make.top.equalTo(imageSlide.snp.bottom).offset(18)
        }
        
        contentView.addSubview(nameLabel)
        nameLabel.text = detailData?.user?.nickName ?? ""
        
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(profileImage.snp.right).offset(12)
            make.centerY.equalTo(profileImage)
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
        //contentDate.text = detailData?.dateTime ?? ""
        
        contentDate.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24)
            make.top.equalTo(contentAddress.snp.bottom).offset(5)
        }
        
        contentView.addSubview(contentText)
        contentText.text = detailData?.content ?? ""
        
        contentText.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24)
            make.top.equalTo(contentDate.snp.bottom).offset(40)
            make.right.equalToSuperview().offset(-24)
        }
        
        bottomLine = UIView()
            .then {
                contentView.addSubview($0)
                $0.backgroundColor = Colors.GRAY_LINE
                $0.snp.makeConstraints { make in
                    make.left.equalToSuperview().offset(24)
                    make.right.equalToSuperview().offset(-24)
                    make.top.equalTo(contentText.snp.bottom).offset(20)
                    make.height.equalTo(1)
                }
            }
    }
    
    func setStar() {
        contentView.addSubview(starImage)
        starImage.snp.makeConstraints { make in
            make.top.equalTo(bottomLine.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(24)
            make.height.width.equalTo(20)
        }
        
        contentView.addSubview(starLabel)
        let rating = Double(detailData?.starRating ?? 0)
        starLabel.text = "\(rating)"
        
        starLabel.snp.makeConstraints { make in
            make.left.equalTo(starImage.snp.right).offset(2)
            make.top.equalTo(bottomLine.snp.bottom).offset(16)
        }
        
        contentView.addSubview(bookmarkImage)
        
        bookmarkImage.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-24)
            make.top.equalTo(bottomLine.snp.bottom).offset(16)
            make.width.height.equalTo(28)
            make.bottom.equalToSuperview().offset(-40)
        }
    }
}

extension AroundDetailView {
    func getImageInputs(imagePaths: [String]) -> [KFSource] {
        let sources = imagePaths.map {
            KFSource(urlString: $0)!
        }
        
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
