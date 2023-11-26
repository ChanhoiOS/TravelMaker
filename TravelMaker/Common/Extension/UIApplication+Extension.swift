//
//  UIApplication+Extension.swift
//  TravelMaker
//
//  Created by 이찬호 on 11/26/23.
//

import UIKit

extension UIApplication {

    static func topMostController() -> UIViewController? {
        guard let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first, let rootViewController = window.rootViewController else {
            return nil
        }

        var topController = rootViewController

        while let newTopController = topController.presentedViewController {
            topController = newTopController
        }

        return topController
    }
}
