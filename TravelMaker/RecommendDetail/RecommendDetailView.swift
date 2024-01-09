//
//  RecommendDetailView.swift
//  TravelMaker
//
//  Created by 이찬호 on 1/8/24.
//

import UIKit
import WebKit
import Then
import SnapKit

class RecommendDetailView: BaseViewController {
    
    @IBOutlet weak var webView: WKWebView!
    var customView: AppleMapBtnView?
    var detailData: RecommendAllData?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setWebView()
        setBackBtn()
    }
    
    func setWebView() {
        let url = URL(string: detailData?.detailURL ?? "")
        let request = URLRequest(url: url!)
        
        webView.load(request)
        
        webView.navigationDelegate = self
    }
    
    func setAppleMapBtn() {
        customView = AppleMapBtnView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
            .then {
                self.view.addSubview($0)
                
                $0.snp.makeConstraints { make in
                    make.bottom.equalToSuperview().offset(-110)
                    make.centerX.equalToSuperview()
                    make.width.equalTo(220)
                    make.height.equalTo(48)
                }
                $0.bringSubviewToFront(self.view)
            }
        
        customView?.jumpMapFunc = jumpMapFunc
        customView?.closeFunc = closeFunc
    }
}

extension RecommendDetailView {
    func jumpMapFunc() {
        let lat = self.detailData?.latitude ?? ""
        let lon = self.detailData?.longitude ?? ""
        let placeName = self.detailData?.placeName ?? ""
        let address = self.detailData?.address ?? ""
        
        let appleUrl = "https://maps.apple.com/?" + "address=" + address + "&ll=" + lat + "," + lon + "&q=" + placeName
        if let url = URL(string: appleUrl) {
            UIApplication.shared.open(url)
        }
    }
    
    func closeFunc() {
        if customView != nil {
            customView?.removeFromSuperview()
        }
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

extension RecommendDetailView: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let url = navigationAction.request.url, url.scheme != "http" && url.scheme != "https" {
            UIApplication.shared.open(url)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        setAppleMapBtn()
    }
    
    
}
