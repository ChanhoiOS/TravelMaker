//
//  MyRecommendCollectionViewCell.swift
//  TravelMaker
//
//  Created by 이찬호 on 11/23/23.
//

import UIKit

class MyRecommendCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var categoryLabel: PaddingLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setUI()
    }
    
    func setUI() {
        categoryLabel.layer.cornerRadius = 12
        categoryLabel.layer.borderWidth = 1
        categoryLabel.layer.borderColor = UIColor.white.cgColor
    }

}
