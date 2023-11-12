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

class RegisterRouteView: UIViewController {

    @IBOutlet weak var bannerConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var spaceStackView: UIStackView!
    @IBOutlet weak var banner: UIImageView!
    @IBOutlet weak var backBtn: UIImageView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var departView: UIView!
    @IBOutlet weak var arriveView: UIView!
    @IBOutlet weak var addLabel: UILabel!
    @IBOutlet weak var removeLabel: UILabel!
    @IBOutlet weak var departLabel: UILabel!
    @IBOutlet weak var departArrow: UIImageView!
    @IBOutlet weak var arriveLabel: UILabel!
    @IBOutlet weak var arriveArrow: UIImageView!
    @IBOutlet weak var addImageBtn: UIButton!
    
    var subViewIndex: Array<UIView>.Index?
    var removeIndex = 0
    
    var disposeBag = DisposeBag()
    
    var spaceFirstView: UIView!
    var count = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        setStackView()
        setGesture()
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
        
        spaceFirstView = UIView()
            .then {
                $0.snp.makeConstraints { make in
                    make.height.equalTo(60)
                }
                
                $0.layer.borderColor = Colors.DESIGN_GRAY.cgColor
                $0.layer.borderWidth = 1
                $0.layer.cornerRadius = 4
            }
            .then {
                var checkBtn = UIButton()
                checkBtn.setImage(UIImage(systemName: "checkmark.rectangle.fill"), for: .normal)
                $0.addSubview(checkBtn)
                
                checkBtn.snp.makeConstraints { make in
                    make.left.equalToSuperview().offset(16)
                    make.width.height.equalTo(24)
                    make.centerY.equalToSuperview()
                }
                
                checkBtn.rx.controlEvent(.touchDown)
                    .bind(onNext: { [weak self] _ in
                        self?.checkSpace(self?.subViewIndex)
                    })
                    .disposed(by: disposeBag)
                
                var searchImage = UIImageView()
                searchImage.image = UIImage(named: "myroute_search")
                $0.addSubview(searchImage)
                
                searchImage.snp.makeConstraints { make in
                    make.right.equalToSuperview().offset(-16)
                    make.width.height.equalTo(28)
                    make.centerY.equalToSuperview()
                }
                
                var spaceLabel = UILabel()
                spaceLabel.text = "장소 선택"
                $0.addSubview(spaceLabel)
                
                spaceLabel.snp.makeConstraints { make in
                    make.left.equalTo(checkBtn.snp.right).offset(10)
                    make.right.equalTo(searchImage.snp.left).offset(16)
                    make.centerY.equalToSuperview()
                }
            }
            
        
        spaceStackView.addArrangedSubview(spaceFirstView)
        
        subViewIndex = spaceStackView.arrangedSubviews.firstIndex(of: spaceFirstView)
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
                var checkBtn = UIButton()
                checkBtn.setImage(UIImage(systemName: "checkmark.rectangle.fill"), for: .normal)
                $0.addSubview(checkBtn)
                
                checkBtn.snp.makeConstraints { make in
                    make.left.equalToSuperview().offset(16)
                    make.width.height.equalTo(24)
                    make.centerY.equalToSuperview()
                }
           
                
                var searchImage = UIImageView()
                searchImage.image = UIImage(named: "myroute_search")
                $0.addSubview(searchImage)
                
                searchImage.snp.makeConstraints { make in
                    make.right.equalToSuperview().offset(-16)
                    make.width.height.equalTo(28)
                    make.centerY.equalToSuperview()
                }
                
                var spaceLabel = UILabel()
                spaceLabel.text = "장소 선택"
                $0.addSubview(spaceLabel)
                
                spaceLabel.snp.makeConstraints { make in
                    make.left.equalTo(checkBtn.snp.right).offset(10)
                    make.right.equalTo(searchImage.snp.left).offset(16)
                    make.centerY.equalToSuperview()
                }
                
                spaceStackView.addArrangedSubview($0)
                
                if let index = spaceStackView.arrangedSubviews.firstIndex(of: $0) {
                    
                    checkBtn.rx.controlEvent(.touchDown)
                        .bind(onNext: { [weak self] _ in
                            self?.checkSpace(index)
                        })
                        .disposed(by: disposeBag)
                }
            }
    }
    
    @objc func removeStackSpace(sender: UITapGestureRecognizer) {
        let subView = spaceStackView.arrangedSubviews[removeIndex]
        spaceStackView.removeArrangedSubview(subView)
        subView.removeFromSuperview()
    }
    
    func checkSpace(_ index: Array<UIView>.Index?) {
        let subView = spaceStackView.arrangedSubviews[index ?? 0]
        
        for sub in subView.subviews {
            if let checkBtn = sub as? UIButton {
                checkBtn.isSelected.toggle()
                
                if checkBtn.isSelected {
                    checkBtn.setImage(UIImage(systemName: "checkmark.rectangle.fill"), for: .normal)
                    removeIndex = index ?? 0
                } else {
                    checkBtn.setImage(UIImage(systemName: "checkmark.rectangle"), for: .normal)
                }
            }
        }
    }
}

extension RegisterRouteView {
    func setGesture() {
        let addSpace = UITapGestureRecognizer(target: self, action: #selector(addStackSpace))
        addLabel.isUserInteractionEnabled = true
        addLabel.addGestureRecognizer(addSpace)
        
        let removeSpace = UITapGestureRecognizer(target: self, action: #selector(removeStackSpace))
        removeLabel.isUserInteractionEnabled = true
        removeLabel.addGestureRecognizer(removeSpace)
    }
}
