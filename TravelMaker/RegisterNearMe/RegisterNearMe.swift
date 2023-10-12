//
//  RegisterNearMe.swift
//  TravelMaker
//
//  Created by 이찬호 on 2023/10/10.
//

import UIKit
import Then
import SnapKit
import Cosmos
import YPImagePicker
import RxSwift
import RxCocoa

class RegisterNearMe: BaseViewController {
    var headerView: UIView!
    var scrollView: UIScrollView!
    var contentView: UIView!
    var headerLine: UIView!
    var starView: UIView!
    var satisficationLabel: UILabel!
    var star: CosmosView!
    var starLine: UIView!
    var dateTextField: UITextField!
    var spaceTextField: UITextField!
    var contentTextView: UITextView!
    var photoStackView: UIStackView!
    
    let date = Date()
    let dateFormatter = DateFormatter()
    var screenWidth: CGFloat?
    var photoWidth: CGFloat?
    var images = [UIImage]()
    
    let disposeBag = DisposeBag()
    
    let textViewPlaceHolder = "Q.\n장소에 대한 리뷰를 남겨주세요.\n최소 15자 이상 작성해 주세요.\n최대 200자 작성 가능합니다."
    
    private let backBtn: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "header_back_btn.png")
        return imageView
    }()
    
    private let pageTitle: UILabel = {
        let label = UILabel()
        label.text = "내 주변 등록"
        label.textColor = Colors.DESIGN_BLACK
        label.font = UIFont(name: "SUIT-Bold", size: 20)
        return label
    }()
    
    private lazy var addPhotoBtn: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "camera_add"), for: .normal)
        button.setTitle("  사진 추가", for: .normal)
        button.setTitleColor(Colors.DESIGN_GRAY, for: .normal)
        button.titleLabel?.font = UIFont(name: "SUIT-Regular", size: 16)
        button.layer.borderWidth = 1.0
        button.layer.borderColor = Colors.DESIGN_WHITE.cgColor
        button.addTarget(self, action: #selector(addPhoto), for: .touchUpInside)
        return button
    }()
    
    private lazy var registerBtn: UIButton = {
        let button = UIButton()
        button.backgroundColor = Colors.DESIGN_GRAY
        button.setTitle("등록하기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "SUIT-Bold", size: 16)
        button.addTarget(self, action: #selector(addPhoto), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        initHeader()
        initScrollView()
        initStarView()
        initContentView()
        initPhotoView()
        initRegisterView()
        
        setGesture()
    }
    
    override func viewDidLayoutSubviews() {
        screenWidth = UIScreen.main.bounds.size.width
        photoWidth = (screenWidth! - 72) / 3
    }
    
    func initHeader() {
        headerView = UIView()
            .then {
                self.view.addSubview($0)
                $0.snp.makeConstraints { make in
                    make.top.equalToSuperview().offset(44)
                    make.left.right.equalToSuperview()
                    make.height.equalTo(59)
                }
            }
        
        headerView.addSubview(backBtn)
        backBtn.snp.makeConstraints { make in
            make.left.equalTo(24)
            make.width.height.equalTo(32)
            make.centerY.equalToSuperview()
        }
        
        headerView.addSubview(pageTitle)
        pageTitle.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        headerLine = UIView()
            .then {
                self.view.addSubview($0)
                $0.backgroundColor = Colors.GRAY_LINE
                $0.snp.makeConstraints { make in
                    make.left.right.equalToSuperview()
                    make.bottom.equalTo(headerView.snp.bottom).offset(0)
                    make.height.equalTo(0.8)
                }
            }
    }
    
    func initScrollView() {
        scrollView = UIScrollView()
            .then {
                self.view.addSubview($0)
                $0.translatesAutoresizingMaskIntoConstraints = false
                $0.snp.makeConstraints { make in
                    make.top.equalTo(headerView.snp.bottom).offset(0)
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
    
    func initStarView() {
        starView = UIView()
            .then {
                contentView.addSubview($0)
                $0.snp.makeConstraints { make in
                    make.left.right.equalToSuperview()
                    make.top.equalTo(contentView.snp.top).offset(0)
                    make.height.equalTo(72)
                }
            }
            .then {
                star = CosmosView()
                $0.addSubview(star)
                star.snp.makeConstraints { make in
                    make.left.equalToSuperview().offset(24)
                    make.top.equalToSuperview().offset(32)
                }
                
                star.settings.updateOnTouch = true
                star.settings.filledColor = Colors.STAR_FILL
                star.settings.emptyBorderColor = Colors.STAR_EMPTY
                star.settings.filledBorderColor = Colors.STAR_FILL
                
                star.didFinishTouchingCosmos = { rating in
                    self.star.rating = rating
                }
                
                star.didTouchCosmos = { rating in
                    self.star.rating = rating
                }
                
            }
            .then {
                satisficationLabel = UILabel()
                $0.addSubview(satisficationLabel)
                satisficationLabel.text = "만족도를 선택해주세요."
                satisficationLabel.snp.makeConstraints { make in
                    make.top.equalToSuperview().offset(32)
                    make.right.equalToSuperview().offset(-24)
                }
            }
        
        starLine = UIView()
            .then {
                contentView.addSubview($0)
                $0.backgroundColor = Colors.DESIGN_WHITE
                $0.snp.makeConstraints { make in
                    make.left.equalToSuperview().offset(24)
                    make.right.equalToSuperview().offset(-24)
                    make.bottom.equalTo(starView.snp.bottom).offset(0)
                    make.height.equalTo(0.8)
                }
            }
    }
    
    func initContentView() {
        dateTextField = UITextField()
        dateTextField.delegate = self
        dateTextField.isUserInteractionEnabled = false
        dateTextField.text = Utils.parsingDate(dateFormatter.string(from: date))
        dateTextField.font = UIFont(name: "SUIT-Bold", size: 18)
        dateTextField.borderStyle = .line
        dateTextField.layer.borderWidth = 1
        contentView.addSubview(dateTextField)
        
        dateTextField.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 16.0, height: 0.0))
        dateTextField.leftViewMode = .always
        
        dateTextField.snp.makeConstraints { make in
            make.top.equalTo(starLine.snp.bottom).offset(24)
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
            make.height.equalTo(60)
        }
        
        spaceTextField = UITextField()
        spaceTextField.delegate = self
        spaceTextField.text = "장소 선택"
        spaceTextField.font = UIFont(name: "SUIT-Bold", size: 18)
        spaceTextField.borderStyle = .line
        spaceTextField.layer.borderWidth = 1
        contentView.addSubview(spaceTextField)
        
        spaceTextField.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 16.0, height: 0.0))
        spaceTextField.leftViewMode = .always
        
        let image = UIImage(named: "register_arrow")
        spaceTextField.withImage("right", image!)
        
        spaceTextField.snp.makeConstraints { make in
            make.top.equalTo(dateTextField.snp.bottom).offset(14)
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
            make.height.equalTo(60)
        }
        
        let guardBtn = UIButton()
        guardBtn.setTitle("", for: .normal)
        guardBtn.backgroundColor = .clear
        spaceTextField.addSubview(guardBtn)
        
        guardBtn.addTarget(self, action: #selector(searchSpace), for: .touchUpInside)
        
        guardBtn.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentTextView = UITextView()
        contentTextView.delegate = self
        contentView.addSubview(contentTextView)
        contentTextView.font = UIFont(name: "SUIT-Bold", size: 18)
        contentTextView.text = textViewPlaceHolder
        contentTextView.textColor = Colors.DESIGN_GRAY
        contentTextView.layer.borderColor = Colors.DESIGN_GRAY.cgColor
        contentTextView.layer.borderWidth = 1.0
        contentTextView.textContainerInset = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)
        
        contentTextView.snp.makeConstraints { make in
            make.top.equalTo(spaceTextField.snp.bottom).offset(14)
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
            make.height.equalTo(327)
        }
    }
    
    func initPhotoView() {
        photoStackView = UIStackView()
            .then {
                contentView.addSubview($0)
                $0.axis = .horizontal
                $0.spacing = 12
                $0.distribution = .fillEqually
                $0.isLayoutMarginsRelativeArrangement = true
            }
            .then {
                $0.snp.makeConstraints { make in
                    make.top.equalTo(contentTextView.snp.bottom).offset(20)
                    make.left.equalToSuperview().offset(24)
                }
            }
        
        contentView.addSubview(addPhotoBtn)
        
        addPhotoBtn.snp.makeConstraints { make in
            make.top.equalTo(photoStackView.snp.bottom).offset(14)
            make.left.equalToSuperview().offset(24)
            make.width.equalTo(113)
            make.height.equalTo(40)
            make.bottom.equalTo(contentView.snp.bottom).offset(-60)
        }
    }
    
    func initRegisterView() {
        self.view.addSubview(registerBtn)
        
        registerBtn.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-44)
            make.left.right.equalToSuperview()
            make.height.equalTo(69)
        }
    }
}

extension RegisterNearMe {
    @objc func searchSpace() {
        let searchView = SearchSpaceView(nibName: "SearchSpaceView", bundle: nil)
        self.navigationController?.pushViewController(searchView, animated: true)
    }
}

extension RegisterNearMe: YPImagePickerDelegate {
    @objc func removePhoto(_ index: Int) {
        var subIndex = index
        
        if subIndex == 0 {
            subIndex = 100
        }
        
        let photoSubview = photoStackView.subviews
        
        for subView in photoSubview {
            if let target = subView.viewWithTag(subIndex) {
                photoStackView.removeArrangedSubview(target)
                subView.removeFromSuperview()
            }
        }
    }
    
    @objc func addPhoto() {
        presentToImagePicker()
    }
    
    func presentSelectedPhoto() {
        for i in 0..<images.count {
            let imageView = UIImageView()
            if i == 0 {
                imageView.tag = 100
            } else {
                imageView.tag = i
            }
           
            photoStackView.addArrangedSubview(imageView)
            imageView.snp.makeConstraints { make in
                make.width.height.equalTo(photoWidth!)
            }
            
            imageView.image = images[i]
            
            let button = UIButton()
            imageView.addSubview(button)
            button.setTitle("", for: .normal)
            button.setImage(UIImage(named: "photo_remove"), for: .normal)
            button.snp.makeConstraints {
                $0.top.equalToSuperview().offset(12)
                $0.right.equalToSuperview().offset(-12)
                $0.width.height.equalTo(24)
            }
            
            imageView.isUserInteractionEnabled = true
                        
            button.rx.controlEvent(.touchDown)
                .bind(onNext: { [weak self] _ in
                    self?.removePhoto(i)
                })
                .disposed(by: disposeBag)
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
            config.library.maxNumberOfItems = 3
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
                
                let subviews = photoStackView.arrangedSubviews
                photoStackView.arrangedSubviews.forEach(photoStackView.removeArrangedSubview(_:))
                subviews.forEach { $0.removeFromSuperview() }
                images.removeAll()
                
                for item in items {
                    switch item {
                    case .photo(let photo):
                        let image: UIImage = photo.image
                        images.append(image)
                    case .video(let video):
                        print("video: ", video)
                    }
                }

                imagePicker.dismiss(animated: true) {
                    if !cancelled {
                        DispatchQueue.main.async {
                            self.presentSelectedPhoto()
                        }
                    }
                }
            }

            imagePicker.modalPresentationStyle = .overFullScreen
            present(imagePicker, animated: true, completion: nil)
        }
}

extension RegisterNearMe {
    func setGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backBtnAction))
        backBtn.addGestureRecognizer(tapGesture)
        backBtn.isUserInteractionEnabled = true
    }
    
    @objc func backBtnAction(sender: UITapGestureRecognizer) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension RegisterNearMe: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
}

extension RegisterNearMe: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if contentTextView.text == textViewPlaceHolder {
            textView.text = nil
            textView.textColor = .black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
           textView.text = textViewPlaceHolder
            textView.textColor = Colors.DESIGN_GRAY
        }
    }
}
