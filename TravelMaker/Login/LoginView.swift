//
//  LoginView.swift
//  TravelMaker
//
//  Created by 이찬호 on 2023/09/11.
//

import UIKit

class LoginView: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func Test(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tabBarController = storyboard.instantiateViewController(withIdentifier: "TabBarViewController") as! TabBarViewController
        
        let recommendView =  RecommendView(nibName: "RecommendView", bundle: nil)
        let arroundView =  ArroundView(nibName: "ArroundView", bundle: nil)
        
        let recommentNavigationView = UINavigationController(rootViewController: recommendView)
        let arroundNavigationView = UINavigationController(rootViewController: arroundView)
        
        tabBarController.setViewControllers([recommentNavigationView, arroundNavigationView], animated: true)
        
        if let items = tabBarController.tabBar.items {
            items[0].selectedImage = UIImage(systemName: "folder.fill")
            items[0].image = UIImage(systemName: "folder")
            items[0].title = "추천"
            
            items[1].selectedImage = UIImage(systemName: "folder.fill")
            items[1].image = UIImage(systemName: "folder")
            items[1].title = "주변"
        }
         
        tabBarController.tabBar.backgroundColor = .white
        
        self.navigationController?.pushViewController(tabBarController, animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
