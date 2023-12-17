//
//  Utils.swift
//  TravelMaker
//
//  Created by 이찬호 on 2023/10/11.
//

import UIKit

class Utils {
    static func parsingDate(_ dateString: String) -> String {
        let endIndex = dateString.index(dateString.startIndex, offsetBy: 10)
        let truncatedString = dateString[..<endIndex]
        
        return String(truncatedString)
    }
    
    static func completionShowAlert(title: String, message: String, topViewController: UIViewController, completion: @escaping () -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default) { _ in
            completion()
        }
        alertController.addAction(okAction)
        topViewController.present(alertController, animated: true)
    }
    
    static func confirmAndCancelAlert(title: String, message: String, topViewController: UIViewController, completion: @escaping () -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default) { _ in
            completion()
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .default) { _ in
            topViewController.dismiss(animated: true)
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        topViewController.present(alertController, animated: true)
    }
    
    static func showToast(_ text: String) {
        guard let topVC = UIApplication.topMostController() else { return }
        
        let containerView = UIView()
        containerView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        containerView.layer.cornerRadius = 10
        containerView.clipsToBounds = true
        
        let toastLabel = UILabel()
        toastLabel.textColor = UIColor.white
        toastLabel.font = UIFont(name: "SUIT-Regular", size: 14)
        toastLabel.textAlignment = .center
        toastLabel.text = text
        
        containerView.addSubview(toastLabel)
        topVC.view.addSubview(containerView)
        
        containerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        toastLabel.snp.makeConstraints { make in
            make.top.equalTo(containerView).offset(10)
            make.leading.equalTo(containerView).offset(10)
            make.bottom.equalTo(containerView).offset(-10)
            make.trailing.equalTo(containerView).offset(-10)
        }
         
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            containerView.alpha = 0.0
        }, completion: {(isCompleted) in
            containerView.removeFromSuperview()
        })
    }
}
