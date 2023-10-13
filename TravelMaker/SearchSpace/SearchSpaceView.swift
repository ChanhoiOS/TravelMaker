//
//  SearchSpaceView.swift
//  TravelMaker
//
//  Created by 이찬호 on 2023/10/12.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa

class SearchSpaceView: BaseViewController {
    
    var headerView: UIView!
    var headerLine: UIView!
    var textField: UITextField!
    var middleLine: UIView!
    
    private let backBtn: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "header_back_btn.png")
        return imageView
    }()
    
    private let pageTitle: UILabel = {
        let label = UILabel()
        label.text = "장소 검색"
        label.textColor = Colors.DESIGN_BLACK
        label.font = UIFont(name: "SUIT-Bold", size: 20)
        return label
    }()
    
    private let recommendTitle: UILabel = {
        let label = UILabel()
        label.text = "추천 장소"
        label.textColor = Colors.DESIGN_BLACK
        label.font = UIFont(name: "SUIT-Bold", size: 18)
        return label
    }()
    
    private let recommendText: UILabel = {
        let label = UILabel()
        label.text = "현재 위치로부터의 거리가 표시됩니다."
        label.textColor = Colors.DESIGN_GRAY
        label.font = UIFont(name: "SUIT-Regular", size: 14)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initHeader()
        initTextField()
        
        setGesture()
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
    
    func initTextField() {
        textField = UITextField()
        textField.delegate = self
        textField.placeholder = "검색어를 입력해 주세요."
        textField.font = UIFont(name: "SUIT-Bold", size: 18)
        textField.backgroundColor = Colors.TEXTFIELD_BACKGROUND
        self.view.addSubview(textField)
        
        textField.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 16.0, height: 0.0))
        textField.leftView?.tintColor = Colors.TEXTFIELD_BACKGROUND
        textField.leftViewMode = .always
        
        let image = UIImage(named: "search_icon")
        textField.withImage("right", image!, .clear)
        
        textField.snp.makeConstraints { make in
            make.top.equalTo(headerLine.snp.bottom).offset(32)
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
            make.height.equalTo(50)
        }
        
        self.view.addSubview(recommendTitle)
        recommendTitle.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom).offset(24)
            make.left.equalToSuperview().offset(24)
        }
        
        self.view.addSubview(recommendText)
        recommendText.snp.makeConstraints { make in
            make.top.equalTo(recommendTitle.snp.bottom).offset(6)
            make.left.equalToSuperview().offset(24)
        }
        
        middleLine = UIView()
            .then {
                self.view.addSubview($0)
                $0.backgroundColor = Colors.GRAY_LINE
                $0.snp.makeConstraints { make in
                    make.left.equalToSuperview().offset(24)
                    make.right.equalToSuperview().offset(-24)
                    make.top.equalTo(recommendText.snp.bottom).offset(16)
                    make.height.equalTo(0.8)
                }
            }
        
    }


}

extension SearchSpaceView {
    func setGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backBtnAction))
        backBtn.addGestureRecognizer(tapGesture)
        backBtn.isUserInteractionEnabled = true
    }
    
    @objc func backBtnAction(sender: UITapGestureRecognizer) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension SearchSpaceView: UITextFieldDelegate {
    
}
