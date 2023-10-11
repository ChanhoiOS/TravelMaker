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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.selectedIndex = 1
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let items = tabBar.items else { return }
        
        for (_ , tabBarItem) in items.enumerated() where tabBarItem == item {
            if tabBarItem.image == UIImage(named: "tabBar_middle") {
                isUploadTabBarEnabled = false
            } else if tabBarItem.image == UIImage(named: "tabBar_register") {
                
                let registerView = RegisterNearMe(nibName: "RegisterNearMe", bundle: nil)
                self.navigationController?.pushViewController(registerView, animated: true)
            } else {
                isUploadTabBarEnabled = true
            }
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

