//
//  RegisterRouteView.swift
//  TravelMaker
//
//  Created by 이찬호 on 11/8/23.
//

import UIKit
import Then
import SnapKit

class RegisterRouteView: UIViewController {

    @IBOutlet weak var bannerConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var spaceStackView: UIStackView!
    @IBOutlet weak var banner: UIImageView!
    
    @IBOutlet weak var addLabel: UILabel!
    @IBOutlet weak var removeLabel: UILabel!
    var count = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setStackView()
        setGesture()
    }

    @IBAction func imageAction(_ sender: Any) {
        bannerConstraint.constant = 180
    }
    
    @IBAction func stackViewAction(_ sender: Any) {
       
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
    func setGesture() {
        let addSpace = UITapGestureRecognizer(target: self, action: #selector(addStackSpace))
        addLabel.isUserInteractionEnabled = true
        addLabel.addGestureRecognizer(addSpace)
        
        let removeSpace = UITapGestureRecognizer(target: self, action: #selector(removeStackSpace))
        removeLabel.isUserInteractionEnabled = true
        removeLabel.addGestureRecognizer(removeSpace)
    }
    
    @objc func addStackSpace(sender: UITapGestureRecognizer) {
        count += 1
        let view = UIView()
        view.snp.makeConstraints { make in
            make.height.equalTo(60)
        }
        let label = UILabel()
        view.addSubview(label)
        
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        label.text = String(count)
       
        view.tag = count
        spaceStackView.addArrangedSubview(view)
    }
    
    @objc func removeStackSpace(sender: UITapGestureRecognizer) {
        let subviews = spaceStackView.arrangedSubviews
    
        for subView in subviews {
            if let target = subView.viewWithTag(count) {
                spaceStackView.removeArrangedSubview(target)
                subView.removeFromSuperview()
                count -= 1
            }
        }
        
        
    }
}
