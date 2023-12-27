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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

}
