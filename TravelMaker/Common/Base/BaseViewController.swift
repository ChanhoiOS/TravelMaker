//
//  BaseViewController.swift
//  TravelMaker
//
//  Created by 이찬호 on 2023/09/12.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureSwipeBackGesture()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    
    func configureSwipeBackGesture() {
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
}
