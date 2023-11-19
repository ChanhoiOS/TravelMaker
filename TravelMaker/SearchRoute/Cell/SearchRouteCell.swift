//
//  SearchRouteCell.swift
//  TravelMaker
//
//  Created by 이찬호 on 11/19/23.
//

import UIKit
import SnapKit

class SearchRouteCell: UITableViewCell {
    static let reuseIdentifier = "SearchRouteCell"
    
    let spaceName = UILabel()
    let spaceAddress = UILabel()

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupAttribute()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setupData(_ name: String, _ address: String) {
        spaceName.text = name
        spaceAddress.text = address
    }
    
    
    private func setupAttribute() {
        spaceName.font = UIFont(name: "SUIT_Bold", size: 16)
        spaceName.textColor = Colors.DESIGN_BLACK
        
        spaceAddress.font = UIFont(name: "SUIT_Bold", size: 16)
        spaceAddress.textColor = Colors.DESIGN_GRAY
    }
    
    private func setupLayout() {
        contentView.addSubview(spaceName)
        spaceName.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.left.equalToSuperview()
        }
        
        contentView.addSubview(spaceAddress)
        spaceAddress.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-12)
        }
    }
}
