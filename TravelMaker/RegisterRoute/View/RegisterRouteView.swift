//
//  RegisterRouteView.swift
//  TravelMaker
//
//  Created by 이찬호 on 11/8/23.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa
import RxGesture
import YPImagePicker

class RegisterRouteView: BaseViewController {

    @IBOutlet weak var bannerConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var spaceStackView: UIStackView!
    @IBOutlet weak var banner: UIImageView!
    @IBOutlet weak var backBtn: UIImageView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var departView: UIView!
    @IBOutlet weak var arriveView: UIView!
    @IBOutlet weak var addLabel: UILabel!
    @IBOutlet weak var departLabel: UILabel!
    @IBOutlet weak var departArrow: UIImageView!
    @IBOutlet weak var arriveLabel: UILabel!
    @IBOutlet weak var arriveArrow: UIImageView!
    @IBOutlet weak var addImageBtn: UIButton!
    
    var subViewIndex: Array<UIView>.Index?
    var removeIndex = 0
    
    var searchRouteViewModel = SearchRouteViewModel.shared
    var disposeBag = DisposeBag()
    
    var spaceFirstView: UIView!
    var selectedImage = UIImage()
    var count = 1
    
    let datePicker = UIDatePicker()
    let dateFormat = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        setStackView()
        setGesture()
        
        setData()
        
        dateFormat.dateFormat = "yyyy-MM-dd"
    }
    
    @IBAction func addBanner(_ sender: Any) {
        presentToImagePicker()
    }
    
    func setUI() {
        titleTextField.addLeftPadding()
        titleTextField.layer.borderColor = Colors.DESIGN_GRAY.cgColor
        titleTextField.layer.borderWidth = 1
        titleTextField.layer.cornerRadius = 4
        departView.layer.borderColor = Colors.DESIGN_GRAY.cgColor
        departView.layer.borderWidth = 1
        departView.layer.cornerRadius = 4
        arriveView.layer.borderColor = Colors.DESIGN_GRAY.cgColor
        arriveView.layer.borderWidth = 1
        arriveView.layer.cornerRadius = 4
        addImageBtn.layer.borderColor = Colors.DESIGN_WHITE.cgColor
        addImageBtn.layer.borderWidth = 1
        addImageBtn.layer.cornerRadius = 4
    }

    func setStackView() {
        spaceStackView.spacing = 20
        spaceStackView.distribution = .equalSpacing
        spaceStackView.isLayoutMarginsRelativeArrangement = true
        spaceStackView.layoutMargins.top = 20.0
        spaceStackView.layoutMargins.left = 0
        spaceStackView.layoutMargins.right = 0
    }
}

extension RegisterRouteView {
    @objc func addStackSpace(sender: UITapGestureRecognizer) {
        count += 1
        
        let addSpaceView = UIView()
            .then {
                $0.snp.makeConstraints { make in
                    make.height.equalTo(60)
                }
                
                $0.layer.borderColor = Colors.DESIGN_GRAY.cgColor
                $0.layer.borderWidth = 1
                $0.layer.cornerRadius = 4
            }
            .then {
                let removeBtn = UIButton()
                removeBtn.setImage(UIImage(systemName: "minus.circle"), for: .normal)
                removeBtn.tag = spaceStackView.subviews.count
                $0.addSubview(removeBtn)
                
                removeBtn.snp.makeConstraints { make in
                    make.left.equalToSuperview().offset(16)
                    make.width.height.equalTo(24)
                    make.centerY.equalToSuperview()
                }
           
                
                let searchImage = UIImageView()
                searchImage.image = UIImage(named: "myroute_search")
                searchImage.tag = spaceStackView.subviews.count + 100
                $0.addSubview(searchImage)
                
                searchImage.snp.makeConstraints { make in
                    make.right.equalToSuperview().offset(-16)
                    make.width.height.equalTo(28)
                    make.centerY.equalToSuperview()
                }
                
                $0.rx.tapGesture()
                        .when(.recognized)
                        .subscribe(onNext: { [weak self] _ in
                            self?.searchSpace(searchImage.tag)
                        })
                    .disposed(by: disposeBag)
                
                let spaceLabel = UILabel()
                spaceLabel.text = "장소 선택"
                spaceLabel.tag = spaceStackView.subviews.count + 200
                $0.addSubview(spaceLabel)
                
                spaceLabel.snp.makeConstraints { make in
                    make.left.equalTo(removeBtn.snp.right).offset(10)
                    make.right.equalTo(searchImage.snp.left).offset(16)
                    make.centerY.equalToSuperview()
                }
                
                spaceStackView.addArrangedSubview($0)
                    
                removeBtn.rx.controlEvent(.touchDown)
                    .bind(onNext: { [weak self] _ in
                        self?.removeSpace(removeBtn.tag)
                    })
                .disposed(by: disposeBag)
            }
    }
    
    func removeSpace(_ index: Int) {
        let subView = spaceStackView.arrangedSubviews[index]
        spaceStackView.removeArrangedSubview(subView)
        subView.removeFromSuperview()

        guard spaceStackView.subviews.count > 0 else { return }
        
        for (index, sub) in spaceStackView.subviews.enumerated() {
            for piece in sub.subviews {
                if let removeBtn = piece as? UIButton {
                    removeBtn.tag = index
                }
                
                if let searchImage = piece as? UIImageView {
                    searchImage.tag = index + 100
                }
                
                if let spaceLabel = piece as? UILabel {
                    spaceLabel.tag = index + 200
                }
            }
        }
    }
}

extension RegisterRouteView {
    func searchSpace(_ index: Int) {
        let searchView = SearchRouteView(nibName: "SearchRouteView", bundle: nil)
        searchView.reactor = SearchRouteViewReactor()
        searchView.index = index
        self.navigationController?.pushViewController(searchView, animated: true)
    }
}

extension RegisterRouteView {
    func setData() {
        searchRouteViewModel.responseSelectedData
            .subscribe(onNext: { [weak self] data in
                self?.setTitle(data)
            })
            .disposed(by: disposeBag)
    }
    
    func setTitle(_ data: [String: Any]) {
        let index = data["index"] as? Int ?? 0
        let labelIndex = index + 100
        
        for (index, sub) in spaceStackView.subviews.enumerated() {
            for piece in sub.subviews {
                if let spaceLabel = piece as? UILabel {
                    if spaceLabel.tag == labelIndex {
                        spaceLabel.text = data["placeTitle"] as? String
                    }
                }
            }
        }
    }
}

extension RegisterRouteView: YPImagePickerDelegate {
    func presentSelectedPhoto() {
        banner.image = selectedImage
        bannerConstraint.constant = 180
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
                        self.presentSelectedPhoto()
                    }
                }
            }
        }
        
        imagePicker.modalPresentationStyle = .overFullScreen
        present(imagePicker, animated: true, completion: nil)
    }
}

extension RegisterRouteView {
    func setGesture() {
        let addSpace = UITapGestureRecognizer(target: self, action: #selector(addStackSpace))
        addLabel.isUserInteractionEnabled = true
        addLabel.addGestureRecognizer(addSpace)
        
        let backGesture = UITapGestureRecognizer(target: self, action: #selector(backBtnAction))
        backBtn.addGestureRecognizer(backGesture)
        backBtn.isUserInteractionEnabled = true
        
        let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(scrollKeyboardHide))
        singleTapGestureRecognizer.numberOfTapsRequired = 1
        singleTapGestureRecognizer.isEnabled = true
        singleTapGestureRecognizer.cancelsTouchesInView = false
        scrollView.addGestureRecognizer(singleTapGestureRecognizer)
        
        let depart = UITapGestureRecognizer(target: self, action: #selector(setDepartLabel))
        departView.isUserInteractionEnabled = true
        departView.addGestureRecognizer(depart)
        
        let arrive = UITapGestureRecognizer(target: self, action: #selector(setArriveLabel))
        arriveView.isUserInteractionEnabled = true
        arriveView.addGestureRecognizer(arrive)
    }
    
    @objc func scrollKeyboardHide(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    @objc func backBtnAction(sender: UITapGestureRecognizer) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension RegisterRouteView {
    @objc func setDepartLabel() {
        let alert = UIAlertController(title: "출발시간", message: "", preferredStyle: .actionSheet)
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.locale = Locale(identifier: "ko_KR")
                
        let confirm = UIAlertAction(title: "선택 완료", style: .cancel) { action in
            self.departLabel.text = Utils.parsingDate(self.dateFormat.string(from: self.datePicker.date))
        }
                        
        alert.addAction(confirm)
                
        let vc = UIViewController()
        vc.view = datePicker
        alert.setValue(vc, forKey: "contentViewController")
        
        self.present(alert, animated: true)
    }
    
    @objc func setArriveLabel() {
        let alert = UIAlertController(title: "도착시간", message: "", preferredStyle: .actionSheet)
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.locale = Locale(identifier: "ko_KR")
                
        let confirm = UIAlertAction(title: "선택 완료", style: .cancel) { action in
            self.arriveLabel.text = Utils.parsingDate(self.dateFormat.string(from: self.datePicker.date))
        }
                        
        alert.addAction(confirm)
                
        let vc = UIViewController()
        vc.view = datePicker
        alert.setValue(vc, forKey: "contentViewController")
        
        self.present(alert, animated: true)
    }
}
