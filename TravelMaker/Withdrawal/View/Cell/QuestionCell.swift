//
//  QuestionCell.swift
//  HealthZZang
//
//  Created by 이찬호 on 2022/08/23.
//

import UIKit
import Then
import SnapKit

class QuestionCell: UICollectionViewCell {
    
    var checkContainer: UIView!
    var checkBox: UIImageView!
    var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        setContents()
    }
    
    func setContents() {
        checkContainer = UIView()
            .then {
                contentView.addSubview($0)
                $0.layer.cornerRadius = 12
                $0.layer.borderWidth = 1
                $0.layer.borderColor = CGColor(red: 243.0/255.0, green: 243.0/255.0, blue: 243.0/255.0, alpha: 1.0)
                $0.backgroundColor = UIColor(red: 243.0/255.0, green: 243.0/255.0, blue: 243.0/255.0, alpha: 1.0)
                $0.snp.makeConstraints { make in
                    make.left.equalToSuperview().offset(20)
                    make.centerY.equalToSuperview()
                    make.width.height.equalTo(24)
                }
            }
        
        checkBox = UIImageView()
            .then {
                checkContainer.addSubview($0)
                $0.image = UIImage(named: "checkCircle")
                $0.snp.makeConstraints { make in
                    make.width.height.equalTo(10)
                    make.centerX.centerY.equalToSuperview()
                }
            }
        
        titleLabel = UILabel()
            .then {
                contentView.addSubview($0)
                $0.textColor = UIColor(red: 139.0/255.0, green: 141.0/255.0, blue: 161.0/255.0, alpha: 1.0)
                $0.font = UIFont(name: "SUIT-Regular", size: 18)
                $0.snp.makeConstraints { make in
                    make.left.equalTo(checkContainer.snp.right).offset(10)
                    make.centerY.equalToSuperview()
                    make.height.equalTo(18)
                }
            }
    }

}
