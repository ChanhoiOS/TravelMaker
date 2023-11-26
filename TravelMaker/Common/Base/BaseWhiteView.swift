//
//  BaseWhiteView.swift
//  TravelMaker
//
//  Created by 이찬호 on 11/26/23.
//

import UIKit
import SnapKit
import Then

class BaseWhiteView: UIViewController {

    var background: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        background = UIView()
            .then {
                self.view.addSubview($0)
                
                $0.backgroundColor = .white
                
                $0.snp.makeConstraints { make in
                    make.edges.equalToSuperview()
                }
            }
    }
}
