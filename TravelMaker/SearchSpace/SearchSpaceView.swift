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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initHeader()
        
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
