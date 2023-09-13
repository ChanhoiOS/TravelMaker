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
    
    let flexView = UIView()
    
    private let backBtn: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "header_back_btn.png")
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setFlexView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        flexView.pin.all(view.pin.safeArea)
        flexView.flex.layout()
    }
    
    func setFlexView() {
        view.addSubview(flexView)
        
        flexView.flex.define { flex in
            flex.addItem().height(59).direction(.row).alignItems(.center).define { flex in
                flex.addItem(backBtn).marginLeft(24).width(32).height(32)
            }
        }
    }

}
