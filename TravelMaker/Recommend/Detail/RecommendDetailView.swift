//
//  RecommendDetailView.swift
//  TravelMaker
//
//  Created by 이찬호 on 11/2/23.
//

import UIKit
import WebKit
import SnapKit
import Then

class RecommendDetailView: UIViewController {
    
    var webView: WKWebView!
    var detailUrl = "https://www.apple.com"
    
    var tabBarHeight: Int = 83

    override func viewDidLoad() {
        super.viewDidLoad()

        getHeight()
        setWebView()
    }
    
    func setWebView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        
        self.view.addSubview(self.webView)
        
        webView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(44)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-64 - tabBarHeight)
        }
        
        let url = URL(string: detailUrl)!
        let request = URLRequest(url: url)
        
        webView.load(request)
    }
   
    func getHeight() {
        tabBarHeight = Int(self.tabBarController?.tabBar.frame.height ?? 49.0)
    }

}
