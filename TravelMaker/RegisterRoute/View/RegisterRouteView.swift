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

class RegisterRouteView: UIViewController {

    @IBOutlet weak var bannerConstraint: NSLayoutConstraint!
    
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
        self.navigationController?.pushViewController(searchView, animated: true)
    }
}

extension RegisterRouteView {
    func setGesture() {
        let addSpace = UITapGestureRecognizer(target: self, action: #selector(addStackSpace))
        addLabel.isUserInteractionEnabled = true
        addLabel.addGestureRecognizer(addSpace)
    }
}
