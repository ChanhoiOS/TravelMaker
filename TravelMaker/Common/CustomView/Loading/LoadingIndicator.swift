//
//  LoadingIndicator.swift
//  HealthZZang
//
//  Created by 이찬호 on 2023/06/01.
//

import UIKit

public class LoadingIndicator {

    public static let shared = LoadingIndicator()
    private var blurImageView = UIImageView()
    private var indicator = UIActivityIndicatorView()
    private var label = UILabel()

    private init() {
        blurImageView.frame = UIScreen.main.bounds
        blurImageView.backgroundColor = UIColor.black
        blurImageView.isUserInteractionEnabled = true
        blurImageView.alpha = 0.5
        indicator.style = .large
        indicator.center = blurImageView.center
        indicator.startAnimating()
        indicator.color = .white
        label.text = ""
        label.textColor = .white
        label.textAlignment = .center
        label.frame = CGRect(x: 0, y: indicator.frame.origin.y + indicator.frame.size.height + 30, width: blurImageView.frame.width, height: 30)
    }

    func showIndicator() {
        DispatchQueue.main.async( execute: {
            UIApplication.shared.windows.filter{$0.isKeyWindow}.first?.addSubview(self.blurImageView)
            UIApplication.shared.windows.filter{$0.isKeyWindow}.first?.addSubview(self.indicator)
            UIApplication.shared.windows.filter{$0.isKeyWindow}.first?.addSubview(self.label)
        })
    }
    func hideIndicator() {
        DispatchQueue.main.async( execute: {
            self.blurImageView.removeFromSuperview()
            self.indicator.removeFromSuperview()
            self.label.removeFromSuperview()
        })
    }
}
