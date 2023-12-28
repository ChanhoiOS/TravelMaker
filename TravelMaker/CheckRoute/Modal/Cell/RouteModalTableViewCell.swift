//
//  RouteModalTableViewCell.swift
//  TravelMaker
//
//  Created by 이찬호 on 12/28/23.
//

import UIKit
import SnapKit

class RouteModalTableViewCell: UITableViewCell {
    static let reuseIdentifier = "RouteModalTableViewCell"
    
    let departArriveLabel: PaddingLabel = {
        let label = PaddingLabel()
        label.textColor = Colors.DESIGN_BLUE
        label.font = UIFont(name: "SUIT-Regular", size: 12)
        label.layer.cornerRadius = 12
        label.layer.borderWidth = 1
        label.layer.borderColor = Colors.DESIGN_BLUE.cgColor
        return label
    }()
    
    var numberView = UIView()
    var numberLabel = UILabel()
    let spaceName = UILabel()
    let spaceAddress = UILabel()
    var grayLine1 = UIView()
    var grayLine2 = UIView()
    var grayLine3 = UIView()

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
        departArriveLabel.font = UIFont(name: "SUIT_Regular", size: 12)
        departArriveLabel.textColor = Colors.DESIGN_BLUE
        
        numberView.backgroundColor = Colors.DESIGN_BLUE
        numberView.layer.cornerRadius = 12
        numberView.layer.masksToBounds = true
        
        numberLabel.font = UIFont(name: "SUIT_Bold", size: 14)
        numberLabel.textColor = .white
        
        spaceName.font = UIFont(name: "SUIT_Bold", size: 16)
        spaceName.textColor = Colors.DESIGN_BLACK
        
        spaceAddress.font = UIFont(name: "SUIT_Bold", size: 16)
        spaceAddress.textColor = Colors.DESIGN_GRAY
        
        grayLine1.backgroundColor = Colors.GRAY_LINE
        grayLine2.backgroundColor = Colors.GRAY_LINE
        grayLine3.backgroundColor = Colors.GRAY_LINE
    }
    
    private func setupLayout() {
        contentView.addSubview(departArriveLabel)
        departArriveLabel.snp.makeConstraints { make in
            make.left.top.equalToSuperview().offset(0)
            make.width.equalTo(50)
        }
        
        contentView.addSubview(numberView)
        numberView.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.top.equalToSuperview().offset(0)
            make.left.equalTo(departArriveLabel.snp.right).offset(10)
        }
        
        numberView.addSubview(numberLabel)
        numberLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        contentView.addSubview(spaceName)
        spaceName.snp.makeConstraints {
            $0.top.equalToSuperview().offset(0)
            $0.left.equalTo(numberView.snp.right).offset(12)
            $0.right.equalToSuperview().offset(-24)
        }
        
        contentView.addSubview(spaceAddress)
        spaceAddress.snp.makeConstraints {
            $0.top.equalTo(spaceName.snp.bottom).offset(2)
            $0.left.equalTo(numberView.snp.right).offset(12)
            $0.right.equalToSuperview().offset(-24)
        }
        
        contentView.addSubview(grayLine1)
        grayLine1.snp.makeConstraints { make in
            make.top.equalTo(numberView.snp.bottom).offset(0)
            make.centerX.equalTo(numberView)
            make.width.equalTo(1)
            make.height.equalTo(5)
        }
        
        contentView.addSubview(grayLine3)
        grayLine3.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(0)
            make.centerX.equalTo(numberView)
            make.width.equalTo(1)
            make.height.equalTo(5)
        }
        
        contentView.addSubview(grayLine2)
        grayLine2.snp.makeConstraints { make in
            make.top.equalTo(grayLine1.snp.bottom).offset(3)
            make.bottom.equalTo(grayLine3.snp.top).offset(-3)
            make.centerX.equalTo(numberView)
            make.width.equalTo(1)
        }
    }
}

