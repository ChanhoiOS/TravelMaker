//
//  ViewController.swift
//  TravelMaker
//
//  Created by 이찬호 on 2023/09/08.
//

import UIKit
import FlexLayout
import PinLayout

class TabBarViewController: UITabBarController {
    
    var isUploadTabBarEnabled = true

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        self.selectedIndex = 2
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.image == UIImage(named: "tabBar_middle") {
            let previousIndex = self.selectedIndex
            self.selectedIndex = previousIndex
            isUploadTabBarEnabled = false
        } else {
            isUploadTabBarEnabled = true
        }
    }

}

extension TabBarViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return isUploadTabBarEnabled
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if let items = self.tabBar.items {
            if selectedIndex == 1 || selectedIndex == 2 {
                items[2].selectedImage = UIImage(named: "tabBar_register")
                items[2].image = UIImage(named: "tabBar_register")
            } else {
                items[2].selectedImage = UIImage(named: "tabBar_middle")
                items[2].image = UIImage(named: "tabBar_middle")
            }
        }
    }
}

