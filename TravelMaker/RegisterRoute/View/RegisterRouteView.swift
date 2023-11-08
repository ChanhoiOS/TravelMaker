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

    @IBOutlet weak var stackConstraint: NSLayoutConstraint!
    @IBOutlet weak var bannerConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var spaceStackView: UIStackView!
    @IBOutlet weak var banner: UIImageView!
    
    @IBOutlet weak var addLabel: UILabel!
    @IBOutlet weak var removeLabel: UILabel!
    var count = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setGesture()
    }


    @IBAction func imageAction(_ sender: Any) {
        
        bannerConstraint.constant = 180
    }
    
    @IBAction func stackViewAction(_ sender: Any) {
       
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
        
        stackConstraint.constant = CGFloat(count * 60)
        let view = UIView()
        view.backgroundColor = .green
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
                stackConstraint.constant = CGFloat(count * 60)
            }
        }
        
        
    }
}
