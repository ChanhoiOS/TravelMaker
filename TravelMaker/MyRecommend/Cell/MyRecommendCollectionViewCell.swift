//
//  MyRecommendCollectionViewCell.swift
//  TravelMaker
//
//  Created by 이찬호 on 11/23/23.
//

import UIKit

class MyRecommendCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var placeImage: UIImageView!
    @IBOutlet weak var bookmarkImage: UIImageView!
    @IBOutlet weak var categoryLabel: PaddingLabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var placename: UILabel!
    
    var deleteAction: ((Int) -> Void)?
    var recommendId = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setUI()
        setGesture()
    }
    
    func setUI() {
        categoryLabel.layer.cornerRadius = 12
        categoryLabel.layer.borderWidth = 1
        categoryLabel.layer.borderColor = UIColor.white.cgColor
    }
    
    func setGesture() {
        let setBookmark = UITapGestureRecognizer(target: self, action: #selector(setBookMark))
        bookmarkImage.addGestureRecognizer(setBookmark)
        bookmarkImage.isUserInteractionEnabled = true
    }
    
    @objc func setBookMark() {
        guard let topVC = UIApplication.topMostController() else { return }
        
        Utils.confirmAndCancelAlert(title: "삭제하시겠습니까?", message: "", topViewController: topVC) {
            if let deleteAction = self.deleteAction {
                deleteAction(self.recommendId)
            }
        }
    }
}
