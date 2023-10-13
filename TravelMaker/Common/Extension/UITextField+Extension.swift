//
//  UITextField+Extension.swift
//  TravelMaker
//
//  Created by 이찬호 on 2023/09/12.
//

import UIKit

extension UITextField {
    func addLeftPadding() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = ViewMode.always
    }
    
    func withImage(_ direction: String, _ image: UIImage, _ color: UIColor? = .white) {
        let mainView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 45))
        mainView.backgroundColor = color
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 45))
        view.backgroundColor = color
        view.clipsToBounds = true
        
        mainView.addSubview(view)

        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: 12.0, y: 10.0, width: 28.0, height: 28.0)
        view.addSubview(imageView)

        if direction == "left" {
            self.leftViewMode = .always
            self.leftView = mainView
        } else {
            self.rightViewMode = .always
            self.rightView = mainView
        }
    }
}
