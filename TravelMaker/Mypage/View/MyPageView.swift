//
//  MyPageView.swift
//  TravelMaker
//
//  Created by 이찬호 on 2023/09/13.
//

import UIKit
import Moya
import PinLayout
import FlexLayout

class MyPageView: UIViewController {
    
    let wrapper = NetworkWrapper<UsersApi>(plugins: [CustomPlugIn()])
    
    private let imageCache = NSCache<NSString, UIImage>()
    let fileManager = FileManager.default
    
    let flexView = UIView()
    
    private let backBtn: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "header_back_btn.png")
        return imageView
    }()
    
    private let pageTitle: UILabel = {
        let label = UILabel()
        label.text = "마이페이지"
        label.textColor = Colors.DESIGN_BLACK
        label.font = UIFont(name: "SUIT-Bold", size: 20)
        return label
    }()
    
    private let profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "empty_profile")
        return imageView
    }()
    
    private let nickName: UILabel = {
        let label = UILabel()
        label.text = "여행가"
        label.textColor = Colors.PRIMARY_BLACK
        label.font = UIFont(name: "SUIT-Bold", size: 20)
        return label
    }()
    
    private let address: UILabel = {
        let label = UILabel()
        label.text = "서울시 서대문구"
        label.textColor = Colors.DESIGN_GRAY
        label.font = UIFont(name: "SUIT-Regular", size: 14)
        return label
    }()
    
    private lazy var editButton: UIButton = {
        let button = UIButton()
        button.setTitle("프로필관리", for: .normal)
        button.setTitleColor(Colors.DESIGN_BLUE, for: .normal)
        button.titleLabel?.font = UIFont(name: "SUIT-Regular", size: 14)
        button.addTarget(self, action: #selector(editProfile), for: .touchUpInside)
        return button
    }()
    
    private let myPostsLabel_1: UILabel = {
        let label = UILabel()
        label.text = "내가 작성한 글"
        label.textColor = Colors.DESIGN_BLACK
        label.font = UIFont(name: "SUIT-Regular", size: 18)
        return label
    }()
    
    private let myPostsLabel_2: UILabel = {
        let label = UILabel()
        label.text = "내가 작성한 글"
        label.textColor = Colors.DESIGN_BLACK
        label.font = UIFont(name: "SUIT-Regular", size: 18)
        return label
    }()
    
    private let myPostsLabel_3: UILabel = {
        let label = UILabel()
        label.text = "내가 작성한 글"
        label.textColor = Colors.DESIGN_BLACK
        label.font = UIFont(name: "SUIT-Regular", size: 18)
        return label
    }()
    
    private lazy var myPostsButton_1: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "myPost_go_btn"), for: .normal)
        button.addTarget(self, action: #selector(goMyPosts), for: .touchUpInside)
        return button
    }()
    
    private lazy var myPostsButton_2: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "myPost_go_btn"), for: .normal)
        button.addTarget(self, action: #selector(goMyPosts), for: .touchUpInside)
        return button
    }()
    
    private lazy var myPostsButton_3: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "myPost_go_btn"), for: .normal)
        button.addTarget(self, action: #selector(goMyPosts), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setFlexView()
        cacheCheck()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchUserData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        flexView.pin.all(view.pin.safeArea)
        flexView.flex.layout()
        
        profileImage.layer.cornerRadius = profileImage.frame.height / 2
    }
    
    func setFlexView() {
        view.addSubview(flexView)
        
        flexView.flex.define { flex in
            flex.addItem().height(59).direction(.row).alignItems(.center).justifyContent(.spaceBetween).define { flex in
                flex.addItem(backBtn).marginLeft(24).width(32).height(32)
                flex.addItem(pageTitle)
                flex.addItem().marginRight(24).width(32)
            }
            
            flex.addItem().height(124).direction(.row).backgroundColor(Colors.DESIGN_MYPAGE_BACKGROUND).justifyContent(.spaceBetween).define { flex in
                flex.addItem(profileImage).marginLeft(24).width(60).height(60).marginVertical(32)
                flex.addItem().paddingRight(80).define { flex in
                    flex.addItem().height(62).define { flex in
                        flex.addItem(nickName).marginTop(38)
                    }
                    flex.addItem().height(62).define { flex in
                        flex.addItem(address).marginBottom(38)
                    }
                }
                flex.addItem().define { flex in
                    flex.addItem().height(62)
                    flex.addItem().height(62).define { flex in
                        flex.addItem(editButton).marginRight(24).marginBottom(38)
                    }
                }
            }
            
            flex.addItem().height(1).backgroundColor(Colors.DESIGN_WHITE).marginHorizontal(24)
            
            flex.addItem().backgroundColor(Colors.DESIGN_MYPAGE_BACKGROUND).define { flex in
            
                flex.addItem().direction(.row).alignItems(.center).marginTop(32).height(58).marginHorizontal(24).backgroundColor(.white).define { flex in
                    flex.addItem(myPostsLabel_1).position(.absolute).left(20)
                    flex.addItem(myPostsButton_1).position(.absolute).right(20)
                }
                
                flex.addItem().direction(.row).alignItems(.center).marginTop(14).height(58).marginHorizontal(24).backgroundColor(.white).define { flex in
                    flex.addItem(myPostsLabel_2).position(.absolute).left(20)
                    flex.addItem(myPostsButton_2).position(.absolute).right(20)
                }
                
                flex.addItem().direction(.row).alignItems(.center).marginTop(14).height(58).marginHorizontal(24).backgroundColor(.white).define { flex in
                    flex.addItem(myPostsLabel_3).position(.absolute).left(20)
                    flex.addItem(myPostsButton_3).position(.absolute).right(20)
                }
            }.grow(2)
            
            flex.addItem().backgroundColor(Colors.DESIGN_MYPAGE_BACKGROUND).grow(1)
        }
    }
    
    func cacheCheck() {
        if let localData = getCacheImage() {
            profileImage.image = localData
        }
    }
}

extension MyPageView {
    @objc func editProfile() {
        
    }
    
    @objc func goMyPosts() {
        
    }
}

extension MyPageView {
    func fetchUserData() {
        wrapper.requestGet(target: .fetchMyData, instance: MyPageModel.self) { response in
            switch response {
            case .success(let data):
                self.setUserData(data)
            case .failure( _):
                print("fetch userData fail")
            }
        }
    }
    
    func setUserData(_ data: MyPageModel) {
        nickName.text = data.data?.nickname ?? "여행자A"
        
        if let localData = getCacheImage() {
            profileImage.image = localData
            return
        }
         
        if let url = data.data?.imagePath {
            _Concurrency.Task {
                do {
                    let imageData = try await loadImage(url)
                    DispatchQueue.main.async {
                        if let image = UIImage(data: imageData) {
                            self.profileImage.image = image
                            self.setMemoryCache(url, image)
                            self.setDiskCache(url, image)
                        }
                    }
                } catch {
                    
                }
            }
        }
    }
        
    func loadImage(_ url: String) async throws -> Data {
        let imageUrl = URL(string: Constants.imageUrl + url)!
        let (data, response) = try await URLSession.shared.data(from: imageUrl)
        
        guard let httpReponse = response as? HTTPURLResponse, httpReponse.statusCode == 200 else {
            throw TMError.loadImageError
        }
        
        return data
    }
}

extension MyPageView {
    func setMemoryCache(_ url: String, _ image: UIImage) {
        var url = url
        
        if url.contains("/") {
            url = url.replacingSlashWithUnderscore()
        }
        
        self.imageCache.setObject(image, forKey: url as NSString)
    }
    
    func setDiskCache(_ url: String, _ image: UIImage) {
        var url = url
        
        if url.contains("/") {
            url = url.replacingSlashWithUnderscore()
        }
        
        guard let path = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first else { return }
        
        var filePath = URL(fileURLWithPath: path)
        filePath.appendPathComponent(url)
        
        if !fileManager.fileExists(atPath: filePath.path) {
            if let data = image.jpegData(compressionQuality: 1.0) {
                do {
                    try data.write(to: filePath)
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        
        if url.contains("/") {
            let pathUrl = url.replacingSlashWithUnderscore()
            UserDefaultsManager.shared.profileCache = pathUrl
        } else {
            UserDefaultsManager.shared.profileCache = url
        }
        
    }
    
    func getCacheImage() -> UIImage? {
        let url = UserDefaultsManager.shared.profileCache
        
        // Memory Cache
        if let image = imageCache.object(forKey: url as NSString) {
            return image
        }
        
        // Disk Cache
        if let path = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first {
            var filePath = URL(fileURLWithPath: path)
            filePath.appendPathComponent(url)
            
            if fileManager.fileExists(atPath: filePath.path) {
                if let imageData = try? Data(contentsOf: filePath), let image = UIImage(data: imageData) {
                    return image
                } else {
                    return nil
                }
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
}
