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
}
