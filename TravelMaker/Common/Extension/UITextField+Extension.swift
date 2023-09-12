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
}
