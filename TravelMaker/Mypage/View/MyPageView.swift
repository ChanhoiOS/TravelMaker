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
import YPImagePicker

class MyPageView: BaseViewController {
    
    let wrapper = NetworkWrapper<UsersApi>(plugins: [CustomPlugIn()])
    
    private let imageCache = NSCache<NSString, UIImage>()
    let fileManager = FileManager.default
    
    var alertView: LogoutAlert?
    var blurView: UIVisualEffectView?
    let flexView = UIView()
    var selectedImage = UIImage()
    var requestModel: RequestProfileImageModel?
    
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
        imageView.layer.cornerRadius = 30
        return imageView
    }()
    
    private let editProfileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "cameraEdit")
        return imageView
    }()
    
    private let nickName: UILabel = {
        let label = UILabel()
        label.text = SessionManager.shared.nickName
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
        button.setTitle("프로필 이미지 변경", for: .normal)
        button.setTitleColor(Colors.DESIGN_BLUE, for: .normal)
        button.titleLabel?.font = UIFont(name: "SUIT-Regular", size: 14)
        button.addTarget(self, action: #selector(editProfile), for: .touchUpInside)
        return button
    }()
    
    private let logoutLabel: UILabel = {
        let label = UILabel()
        label.text = "로그아웃"
        label.textColor = Colors.DESIGN_BLACK
        label.font = UIFont(name: "SUIT-Regular", size: 18)
        return label
    }()
    
    private let withdrawalLabel: UILabel = {
        let label = UILabel()
        label.text = "회원 탈퇴"
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
    
    private lazy var logoutAction: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "myPost_go_btn"), for: .normal)
        button.addTarget(self, action: #selector(logout), for: .touchUpInside)
        return button
    }()
    
    private lazy var withdrawalAtion: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "myPost_go_btn"), for: .normal)
        button.addTarget(self, action: #selector(withdrawal), for: .touchUpInside)
        return button
    }()
    
    private lazy var myPostsButton_3: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "myPost_go_btn"), for: .normal)
        button.addTarget(self, action: #selector(goMyPosts), for: .touchUpInside)
        return button
    }()
    
    private let logoutView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let withdrawalView: UIView = {
        let view = UIView()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setFlexView()
        cacheCheck()
        setGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchUserData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        flexView.pin.all(view.pin.safeArea)
        flexView.flex.layout()
        
        profileImage.clipsToBounds = true
        profileImage.layer.cornerRadius = 30
    }
    
    func setFlexView() {
        view.addSubview(flexView)
        
        flexView.flex.define { flex in
            flex.addItem().height(59).direction(.row).alignItems(.center).justifyContent(.spaceBetween).define { flex in
                flex.addItem(backBtn).marginLeft(24).width(32).height(32)
                flex.addItem(pageTitle)
                flex.addItem().marginRight(24).width(32)
            }
            
            flex.addItem().height(124).direction(.row).backgroundColor(Colors.DESIGN_BACKGROUND).justifyContent(.spaceBetween).define { flex in
                flex.addItem(profileImage).marginLeft(24).width(60).height(60).marginVertical(32).cornerRadius(30)
                flex.addItem().paddingRight(80).define { flex in
                    flex.addItem().height(62).define { flex in
                        flex.addItem(nickName).marginTop(38).marginLeft(10)
                    }
                    flex.addItem().height(62).define { flex in
                        flex.addItem(address).marginBottom(30).marginLeft(10)
                    }
                }
                flex.addItem().define { flex in
                    flex.addItem().height(62)
                    flex.addItem().height(62).define { flex in
                        flex.addItem(editButton).marginRight(24).marginBottom(30)
                    }
                }
            }
            
            flex.addItem().height(1).backgroundColor(Colors.DESIGN_WHITE).marginHorizontal(24)
            
            flex.addItem().backgroundColor(Colors.DESIGN_BACKGROUND).define { flex in
                
                flex.addItem(logoutView).direction(.row).alignItems(.center).marginTop(32).height(58).marginHorizontal(24).backgroundColor(.white).define { flex in
                    flex.addItem(logoutLabel).position(.absolute).left(20)
                    flex.addItem(logoutAction).position(.absolute).right(20)
                }
                
                flex.addItem(withdrawalView).direction(.row).alignItems(.center).marginTop(14).height(58).marginHorizontal(24).backgroundColor(.white).define { flex in
                    flex.addItem(withdrawalLabel).position(.absolute).left(20)
                    flex.addItem(withdrawalAtion).position(.absolute).right(20)
                }
                /*
                 flex.addItem().direction(.row).alignItems(.center).marginTop(14).height(58).marginHorizontal(24).backgroundColor(.white).define { flex in
                 flex.addItem(myPostsLabel_3).position(.absolute).left(20)
                 flex.addItem(myPostsButton_3).position(.absolute).right(20)
                 }
                 */
            }.grow(2)
            
            flex.addItem().backgroundColor(Colors.DESIGN_BACKGROUND).grow(1)
        }
    }
}

extension MyPageView {
    func setGesture() {
        let logout = UITapGestureRecognizer(target: self, action: #selector(logout))
        logoutView.addGestureRecognizer(logout)
        logoutView.isUserInteractionEnabled = true
        
        let withdrawal = UITapGestureRecognizer(target: self, action: #selector(withdrawal))
        withdrawalView.addGestureRecognizer(withdrawal)
        withdrawalView.isUserInteractionEnabled = true
    }
}
    
extension MyPageView {
    @objc func editProfile() {
        presentToImagePicker()
    }
    
    @objc func goMyPosts() {
        
    }
}

extension MyPageView {
    @objc func logout() {
        self.blurView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        self.blurView?.frame = self.view.bounds
        self.view.addSubview(self.blurView ?? UIVisualEffectView())
        self.alertView = LogoutAlert(frame: CGRect(x: 0, y: 0, width: 335, height: 250))
        self.alertView?.center = self.view.center
        self.alertView?.logoutAction = self.goLogout
        self.alertView?.closeAction = self.closeAction
        self.view.addSubview(self.alertView ?? UIView())
    }
    
    func closeAction() {
        self.blurView?.removeFromSuperview()
        self.blurView = nil
        self.alertView?.removeFromSuperview()
        alertView = nil
    }
    
    func goLogout() {
        SessionManager.shared.profileUrl = ""
        SessionManager.shared.nickName = ""
        SessionManager.shared.loginId = ""
        SessionManager.shared.loginType = ""
        SessionManager.shared.accessToken = ""
        
        let vc = LoginView(nibName: "LoginView", bundle: nil)
        self.tabBarController?.navigationController?.offAllNamed(vc)
    }
    
    @objc func withdrawal() {
        let vc = WithdrawalView(nibName: "WithdrawalView", bundle: nil)
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension MyPageView: YPImagePickerDelegate {
    func uploadSelectedPhoto() {
        var imageData = Data()
        
        let resizeImage = selectedImage.resize(newWidth: 100)
        let imageJpg = resizeImage.jpegData(compressionQuality: 1.0)!
        imageData.append(imageJpg)
        
        requestModel = RequestProfileImageModel(
            imageFiles: imageData
        )
        
        FileUploadRepository.shared.uploadProfileData(url: Apis.update_image, with: requestModel!) { response in
            print("내 프로필 이미지 등록 성공: ", response)
            self.setUserData(response)
            LoadingIndicator.shared.hideIndicator()
        } failureHandler: { error in
            print("내 프로필 이미지 error: ", error)
            LoadingIndicator.shared.hideIndicator()
        }
    }
    
    func imagePickerHasNoItemsInLibrary(_ picker: YPImagePicker) {
        print("사진 가져오기 에러")
    }
    
    func shouldAddToSelection(indexPath: IndexPath, numSelections: Int) -> Bool {
        return true
    }
    
    private func presentToImagePicker() {
        var config = YPImagePickerConfiguration()
        config.library.mediaType = .photo
        config.library.defaultMultipleSelection = false
        config.library.maxNumberOfItems = 1
        config.screens = [.library]
        config.startOnScreen = .library
        // cropping style 을 square or not 으로 지정.
        config.library.isSquareByDefault = true
        // 필터 단계 스킵.
        config.showsPhotoFilters = false
        config.showsCrop = .rectangle(ratio: 1.0)
        
        config.shouldSaveNewPicturesToAlbum = false
        
        let imagePicker = YPImagePicker(configuration: config)
        imagePicker.imagePickerDelegate = self
        
        imagePicker.didFinishPicking { [weak self] items, cancelled in
            guard let self = self else { return }
            
            for item in items {
                switch item {
                case .photo(let photo):
                    selectedImage = photo.image
                case .video(let video):
                    print("video: ", video)
                }
            }
            
            imagePicker.dismiss(animated: true) {
                if !cancelled {
                    DispatchQueue.main.async {
                        LoadingIndicator.shared.showIndicator()
                        self.uploadSelectedPhoto()
                    }
                }
            }
        }
        
        imagePicker.modalPresentationStyle = .overFullScreen
        present(imagePicker, animated: true, completion: nil)
    }
}

extension MyPageView {
    func cacheCheck() {
        if let localData = getCacheImage() {
            profileImage.image = localData
        }
        
        if SessionManager.shared.nickName != "" {
            nickName.text = SessionManager.shared.nickName
        }
    }
    
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
        /*
        if let localData = getCacheImage() {
            profileImage.image = localData
        }
         */
        
        if let url = data.data?.imageURL {
            SessionManager.shared.profileUrl = url
            _Concurrency.Task {
                do {
                    let imageData = try await loadImage(url)
                    DispatchQueue.main.async {
                        if let image = UIImage(data: imageData) {
                            self.profileImage.image = image
                            //self.setMemoryCache(url, image)
                            //self.setDiskCache(url, image)
                        }
                    }
                } catch {
                    
                }
            }
        }
    }
        
    func loadImage(_ url: String) async throws -> Data {
        let imageUrl = URL(string: url)!
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
