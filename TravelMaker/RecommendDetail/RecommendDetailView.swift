//
//  RecommendDetailView.swift
//  TravelMaker
//
//  Created by 이찬호 on 1/8/24.
//

import UIKit
import WebKit

class RecommendDetailView: BaseViewController {
    
    @IBOutlet weak var webView: WKWebView!
    
    var detailUrl = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setWebView()
        setBackBtn()
    }
    
    func setWebView() {
        let url = URL(string: detailUrl)
        let request = URLRequest(url: url!)
        
        webView.load(request)
    }
}

extension RecommendDetailView {
    func setBackBtn() {
        let floatyBtn = ScrollFlotyBtnView(frame: CGRect(x: self.view.frame.width - 64, y: self.view.frame.height - 96, width: 48, height: 48))
        floatyBtn.backFunc = backFunc
        self.view.addSubview(floatyBtn)
        
        floatyBtn.bringSubviewToFront(self.view)
    }
    
    func backFunc() {
        self.navigationController?.popViewController(animated: true)
    }
}
