//
//  RouteModal.swift
//  TravelMaker
//
//  Created by 이찬호 on 12/28/23.
//

import UIKit

protocol FocusRoute {
    func focus(_ route: RouteAddress?)
}

class RouteModal: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var model: ResponseRegisterRoute?
    var delegate: FocusRoute?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setTable()
    }
    
    func setTable() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(RouteModalTableViewCell.self, forCellReuseIdentifier: RouteModalTableViewCell.reuseIdentifier)
        tableView.separatorStyle = .none
    }
}

extension RouteModal: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model?.routeAddress?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RouteModalTableViewCell", for: indexPath) as! RouteModalTableViewCell
        cell.selectionStyle = .none
        
        let count = model?.routeAddress?.count ?? 0
        let data =  model?.routeAddress
        
        if indexPath.row == 0 {
            cell.departArriveLabel.text = "출발"
            cell.departArriveLabel.isHidden = false
            if count == 1 {
                cell.grayLine1.isHidden = true
                cell.grayLine2.isHidden = true
                cell.grayLine3.isHidden = true
            }
        } else if indexPath.row == count - 1 {
            cell.departArriveLabel.isHidden = false
            cell.departArriveLabel.text = "도착"
            cell.grayLine1.isHidden = true
            cell.grayLine2.isHidden = true
            cell.grayLine3.isHidden = true
        } else {
            cell.departArriveLabel.isHidden = true
        }
        
        cell.numberLabel.text = "\(indexPath.row)"
        cell.spaceName.text = data?[indexPath.row].addressName ?? ""
        cell.spaceAddress.text = data?[indexPath.row].addressDetail ?? ""
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = model?.routeAddress?[indexPath.row]
        delegate?.focus(data)
    }
}
