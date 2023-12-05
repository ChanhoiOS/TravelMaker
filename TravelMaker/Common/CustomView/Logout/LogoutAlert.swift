//
//  LogoutAlert.swift
//  TravelMaker
//
//  Created by 이찬호 on 12/5/23.
//

import UIKit

class LogoutAlert: UIView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var logoutBtn: UIButton!
    @IBOutlet weak var closeBtn: UIButton!
    
    var closeAction: (() -> Void)?
    var logoutAction: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        customInit()
    }

    required init?(coder: NSCoder) {
       super.init(coder: coder)
       customInit()
    }
    
    @IBAction func alertClose(_ sender: Any) {
        if let closeAction = closeAction {
            closeAction()
        }
    }
    
    @IBAction func alertLogout(_ sender: Any) {
        if let logoutAction = logoutAction {
            logoutAction()
        }
    }
    
    func customInit() {
        if let view = Bundle.main.loadNibNamed("LogoutAlert", owner: self, options: nil)?.first as? UIView {
            view.frame = self.bounds
            addSubview(view)
        }

        titleLabel.font = UIFont(name: "SUIT-Bold", size: 36)
        contentLabel.font = UIFont(name: "SUIT-Regular", size: 16)
        logoutBtn.titleLabel?.font = UIFont(name: "SUIT-Bold", size: 18)
        logoutBtn.layer.cornerRadius = 5
        logoutBtn.layer.masksToBounds = true
        closeBtn.setTitle("", for: .normal)
        layer.cornerRadius = 5
        layer.masksToBounds = true
    }
}
