//
//  UIView+Extension.swift
//  TravelMaker
//
//  Created by 이찬호 on 11/29/23.
//

import UIKit

extension UIView {
    
    public var topSafeAreaHeight: CGFloat {
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        return window?.safeAreaInsets.top ?? 0
    }
    
    public var bottomSafeAreaHeight: CGFloat {
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        return window?.safeAreaInsets.bottom ?? 0
    }
    
    public var safeAreaFrame: CGRect {

        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        let topPadding = window?.safeAreaInsets.top ?? 0
        let bottomPadding = window?.safeAreaInsets.bottom ?? 0
        
        return CGRect(x: 0, y: topPadding, width: self.frame.width, height: UIScreen.main.bounds.height - topPadding - bottomPadding)
    }
    
    var parentViewController: UIViewController? {
            var parentResponder: UIResponder? = self
            while parentResponder != nil {
                parentResponder = parentResponder!.next
                if let viewController = parentResponder as? UIViewController {
                    return viewController
                }
            }
            return nil
        }
    
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
    
}
