//
//  UINavigationController+Extension.swift
//  TravelMaker
//
//  Created by 이찬호 on 10/23/23.
//

import UIKit

extension UINavigationController {
    func toNamed(_ vc: UIViewController, params: [String: Any]? = nil) {
        self.pushViewController(vc, animated: true)
    }
    
    func offAllNamed(_ vc: UIViewController, params: [String: Any]? = nil) {
        self.setViewControllers([vc], animated: true)
    }
    
    func replace(_ vc: UIViewController, params: [String: Any]? = nil) {
        let popVC = self.viewControllers.popLast()
        self.pushViewController(vc, animated: true)
    }
    
    func popTo(_ name: String) {
        self.viewControllers.forEach { vc in
            if let nibName = vc.nibName {
                if nibName == name {
                    self.popToViewController(vc, animated: true)
                    return
                }
             }
         }
    }
}
