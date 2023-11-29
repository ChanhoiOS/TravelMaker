//
//  CommonHeader.swift
//  TravelMaker
//
//  Created by 이찬호 on 11/29/23.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Then

class CommonHeader: UIView {
    var headerTitle = "HEADER TITLE"
    var headerType : CommonHeaderType = .normal
    var onTextFieldChanged: ((String?) -> ())?
    var searchText = ""
    var searchTextField: UITextField!
    let disposeBag = DisposeBag()
    var onBackAction: (() -> Void)?
    
    override init(frame: CGRect){
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configureUI() {
        //백 버튼
        let backButton = UIImageView(image: UIImage(named: "common_header_backbtn"))
            .then {
                self.addSubview($0)
                $0.snp.makeConstraints { make in
                    make.centerY.equalToSuperview()
                    make.width.height.equalTo(24)
                    make.leading.equalToSuperview().offset(20)
                }
            }
            .then {
                $0.rx.tapGesture()
                    .when(.recognized)
                    .bind(onNext: { [weak self] _ in
                        self?.parentViewController?.navigationController?.popViewController(animated: true)
                    })
                    .disposed(by: disposeBag)
            }
        
        if self.headerType == .normal {
            //타이틀
            UILabel()
                .do {
                    self.addSubview($0)
                    $0.snp.makeConstraints { make in
                        make.centerY.equalToSuperview()
                        make.left.equalTo(backButton.snp.right).offset(6)
                    }
                    $0.font = UIFont(name: "SUIT-Bold", size: 24)
                    $0.text = self.headerTitle
                }
        }
        
        if self.headerType == .search {
            
            //검색창
            UIView()
                .then {
                    self.addSubview($0)
                    $0.layer.cornerRadius = 5
                    $0.backgroundColor = UIColor(named: "#F3F3F3")
                    $0.snp.makeConstraints { make in
                        make.centerY.equalToSuperview()
                        make.left.equalTo(backButton.snp.right).offset(16)
                        make.right.equalToSuperview().offset(-20)
                        make.height.equalTo(40)
                    }
                }
                .do {
                    //돋보기 아이콘
                    let searchTextFieldIcon = UIImage(named: "Magnifying Glass")
                    let searchTextFieldIconView = UIImageView(image: searchTextFieldIcon)
                    $0.addSubview(searchTextFieldIconView)
                    searchTextFieldIconView.snp.makeConstraints { maker in
                        maker.width.height.equalTo(16)
                        maker.centerY.equalToSuperview()
                        maker.left.equalToSuperview().offset(14)
                    }
                    
                    //"헬짱 통합검색"
                    searchTextField = UITextField()
                    searchTextField.placeholder = "헬짱 통합검색"
                    searchTextField.font = UIFont(name: "SUIT-Regular", size: 16)
                    searchTextField.backgroundColor = .none
                    $0.addSubview(searchTextField)
                    searchTextField.snp.makeConstraints { maker in
                        maker.left.equalTo(searchTextFieldIconView.snp.right).offset(5)
                        maker.right.equalToSuperview().offset(-12)
                        maker.centerY.equalToSuperview()
                        maker.height.equalToSuperview()
                    }
                    
                    searchTextField.rx.text
                        .orEmpty
                        .skip(1)
                        .bind(onNext: {[weak self] text in
                            self?.searchText = text
                        })
                        .disposed(by: disposeBag)
                    
                    searchTextField.rx.controlEvent(.editingDidEndOnExit)
                        .bind(onNext: {[weak self] _ in
                            if let onTextFieldChanged = self?.onTextFieldChanged {
                                guard self?.searchText != "" else { return }
                                onTextFieldChanged(self?.searchText)
                            }
                        })
                        .disposed(by: disposeBag)
                }
            
        }
    }
}

enum CommonHeaderType {
    case normal
    case search
}

class CommonHeaderBuilder {
    private var headerTitle = "HEADER TITLE"
    private var headerType : CommonHeaderType = .normal
    private var onTextFieldChanged: ((String?) -> ())?
    private var onBackAction: (() -> Void)?
    let disposeBag = DisposeBag()
    
    func setHeaderTitle(_ headerTitle: String) -> CommonHeaderBuilder {
        self.headerTitle = headerTitle
        return self
    }
    
    func setHeaderType(_ headerType: CommonHeaderType) -> CommonHeaderBuilder {
        self.headerType = headerType
        return self
    }
    
    func setTextFieldChangedListener(_ onTextFieldChanged: @escaping ((String?) -> ())) -> CommonHeaderBuilder {
        self.onTextFieldChanged = onTextFieldChanged
        return self
    }
    
    func setBackButtonListener(_ onBackAction: @escaping (() -> Void)) -> CommonHeaderBuilder {
        self.onBackAction = onBackAction
        return self
    }
    
    func build() -> CommonHeader {
        return CommonHeader()
            .then {
                $0.headerTitle = self.headerTitle
                $0.headerType = self.headerType
            }
            .then {
                $0.configureUI()
            }
            .then {
                $0.onTextFieldChanged = self.onTextFieldChanged
            }
            .then {
                $0.onBackAction = self.onBackAction
            }
            
    }
}
