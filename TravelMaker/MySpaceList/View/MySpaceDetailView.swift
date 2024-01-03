//
//  MySpaceDetailView.swift
//  TravelMaker
//
//  Created by 이찬호 on 1/3/24.
//

import UIKit
import Then
import SnapKit
import ReactorKit
import RxSwift
import RxCocoa
import ImageSlideshow
import Kingfisher

class MySpaceDetailView: BaseViewController {
    var scrollView: UIScrollView!
    var contentView: UIView!
    var profileLine: UIView!
    var bottomLine: UIView!
    
    var imageSlide: ImageSlideshow!
    
    var serverDetailData: ResponseAroundDetailModel?
    var nearbyId: Int?
    
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

        setBookmarkedData()
        
        setScrollView()
        
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
                
                if let imagesPath = serverDetailData?.data?.imgList {
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
        nameLabel.text = serverDetailData?.data?.user?.nickName ?? ""
        
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
        contentTitle.text = serverDetailData?.data?.placeName ?? ""
        
        contentTitle.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24)
            make.top.equalTo(profileLine.snp.bottom).offset(20)
        }
        
        contentView.addSubview(contentAddress)
        contentAddress.text = serverDetailData?.data?.address ?? ""
        
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
        contentText.text = serverDetailData?.data?.content ?? ""
        
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
        let rating = Double(serverDetailData?.data?.starRating ?? 0)
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

extension MySpaceDetailView {
    func getImageInputs(imagePaths: [String]) -> [KFSource] {
        let sources = imagePaths.map {
            KFSource(urlString: $0)!
        }
        
        return sources
    }
}

extension MySpaceDetailView {
    func setGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backBtnAction))
        backBtn.addGestureRecognizer(tapGesture)
        backBtn.isUserInteractionEnabled = true
        
        let tapBookmark = UITapGestureRecognizer(target: self, action: #selector(switchBookmark))
        bookmarkImage.addGestureRecognizer(tapBookmark)
        bookmarkImage.isUserInteractionEnabled = true
        
        //scrollView.addGestureRecognizer(tapGesture)
    }
    
    @objc func backBtnAction(sender: UITapGestureRecognizer) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension MySpaceDetailView {
    func setBookmarkedData() {
        let url = Apis.nearby_one + "/\(nearbyId ?? 0)"
        Task {
            do {
                let response = try await AsyncNetworkManager.shared.asyncGet(url, ResponseAroundDetailModel.self)
                serverDetailData = response
                
                setImageSlide()
                setProfile()
                setContent()
                setStar()
                
                let bookmarked = response.data?.bookmarked ?? false
                
                if bookmarked {
                    bookmarkImage.image = UIImage(named: "recommend_bookmark_fiill")
                }
            } catch {
                
            }
        }
    }
    
    @objc func switchBookmark() {
        var paramDic = [String: Any]()
        let nearbyId = serverDetailData?.data?.nearbyID ?? 0
        paramDic["nearby_id"] = nearbyId
        
        let bookmarked = serverDetailData?.data?.bookmarked ?? false
        
        if bookmarked {
            Task {
                do {
                    let response = try await AsyncNetworkManager.shared.asyncDelete(Apis.nearby_delete_bookmark, paramDic, DeleteNearByBookmarkModel.self)
                    if response.message == "성공" {
                        bookmarkImage.image = UIImage(named: "detail_bookmark")
                        Utils.showToast("즐겨찾기 해제")
                        serverDetailData?.data?.bookmarked = false
                    } else {
                        Utils.showToast("즐겨찾기 해제에 실패하였습니다. 잠시 후에 다시 시도해주세요.")
                    }
                } catch {
                    Utils.showToast("즐겨찾기 해제에 실패하였습니다. 잠시 후에 다시 시도해주세요.")
                }
            }
        } else {
            Task {
                do {
                    let response = try await AsyncNetworkManager.shared.asyncPost(Apis.nearby_add_bookmark, paramDic, SetNearByBookmarkModel.self)
                    if response.message == "성공" {
                        bookmarkImage.image = UIImage(named: "recommend_bookmark_fiill")
                        Utils.showToast("즐겨찾기 등록")
                        serverDetailData?.data?.bookmarked = true
                    } else {
                        Utils.showToast("즐겨찾기 등록에 실패하였습니다. 잠시 후에 다시 시도해주세요.")
                    }
                } catch {
                    Utils.showToast("즐겨찾기 등록에 실패하였습니다. 잠시 후에 다시 시도해주세요.")
                }
            }
        }
    }
}

