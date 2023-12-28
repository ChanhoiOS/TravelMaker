//
//  MyRouteView.swift
//  TravelMaker
//
//  Created by 이찬호 on 11/3/23.
//

import UIKit

class MyRouteView: BaseViewController {

    @IBOutlet weak var plusBtn: UIImageView!
    @IBOutlet weak var backBtn: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var collectionData: ResponseRegisterRouteModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setCollectionView()
        setGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setData()
    }
    
    func setCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(UINib(nibName: "MyRouteCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MyRouteCollectionViewCell")
    }
}

extension MyRouteView {
    func setData() {
        let url = Apis.route_all
        
        _Concurrency.Task {
            do {
                let response = try await AsyncNetworkManager.shared.asyncGet(url, ResponseRegisterRouteModel.self)
                collectionData = response
                
                collectionView.reloadData()
            } catch {
                
            }
        }
    }
}

extension MyRouteView {
    func setGesture() {
        let backGesture = UITapGestureRecognizer(target: self, action: #selector(backBtnAction))
        backBtn.addGestureRecognizer(backGesture)
        backBtn.isUserInteractionEnabled = true
        
        let plusGesture = UITapGestureRecognizer(target: self, action: #selector(registerAction))
        plusBtn.addGestureRecognizer(plusGesture)
        plusBtn.isUserInteractionEnabled = true
    }
    
    @objc func backBtnAction(sender: UITapGestureRecognizer) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func registerAction(sender: UITapGestureRecognizer) {
        let registerRoute = RegisterRouteView(nibName: "RegisterRouteView", bundle: nil)
        self.navigationController?.pushViewController(registerRoute, animated: true)
    }
}

extension MyRouteView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionData?.data?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyRouteCollectionViewCell", for: indexPath) as! MyRouteCollectionViewCell
        
        let backgroundUrl = collectionData?.data?[indexPath.row].fileURL ?? ""
        let url = URL(string: backgroundUrl)
        cell.routeImage.kf.setImage(with: url)
        cell.routeTitle.text = collectionData?.data?[indexPath.row].title ?? ""
        
        let startDate = collectionData?.data?[indexPath.row].startDate ?? ""
        let endDate = collectionData?.data?[indexPath.row].endDate ?? ""
        
        cell.routeDate.text = startDate + " ~ " + endDate
        
        cell.contentView.layer.borderColor = Colors.DESIGN_WHITE.cgColor
        cell.contentView.layer.borderWidth = 1
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = CheckRouteView(nibName: "CheckRouteView", bundle: nil)
        vc.collectionData = collectionData?.data?[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.bounds.width - 48, height: 260)
    }
}
