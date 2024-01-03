//
//  MyRouteCollectionViewCell.swift
//  TravelMaker
//
//  Created by 이찬호 on 11/3/23.
//

import UIKit

class MyRouteCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var routeImage: UIImageView!
    @IBOutlet weak var deleteLabel: UILabel!
    @IBOutlet weak var routeDate: UILabel!
    @IBOutlet weak var routeTitle: UILabel!
    
    var routeInfoId: Int = 0
    var deleteAction: ((Int) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setGesture()
    }

    func setGesture() {
        let deleteRoute = UITapGestureRecognizer(target: self, action: #selector(deleteRoute))
        deleteLabel.addGestureRecognizer(deleteRoute)
        deleteLabel.isUserInteractionEnabled = true
    }
    
    @objc func deleteRoute() {
        guard let topVC = UIApplication.topMostController() else { return }
        
        Utils.confirmAndCancelAlert(title: "삭제하시겠습니까?", message: "", topViewController: topVC) {
            if let deleteAction = self.deleteAction {
                deleteAction(self.routeInfoId)
            }
        }
    }
}
