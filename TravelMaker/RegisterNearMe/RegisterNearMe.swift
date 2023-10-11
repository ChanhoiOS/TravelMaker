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

class RegisterNearMe: UIViewController {
    
    var headerView: UIView!
    var scrollView: UIScrollView!
    var headerLine: UIView!
    var starView: UIView!
    var satisficationLabel: UILabel!
    var star: CosmosView!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initHeader()
        initScrollView()
        initStarView()
        setGesture()
    }
    
    override func viewDidLayoutSubviews() {
       
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
    }
    
    func initStarView() {
        starView = UIView()
            .then {
                self.view.addSubview($0)
                $0.snp.makeConstraints { make in
                    make.left.right.equalToSuperview()
                    make.top.equalTo(scrollView.snp.top).offset(0)
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
                
//                star.didFinishTouchingCosmos = { rating in
//                    self.star.rating = rating
//                }
                
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
