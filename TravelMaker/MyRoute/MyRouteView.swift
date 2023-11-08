//
//  MyRouteView.swift
//  TravelMaker
//
//  Created by 이찬호 on 11/3/23.
//

import UIKit

class MyRouteView: UIViewController {

    @IBOutlet weak var plusBtn: UIImageView!
    @IBOutlet weak var backBtn: UIImageView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setCollectionView()
        setGesture()
    }
    
    func setCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UINib(nibName: "MyRouteCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MyRouteCollectionViewCell")
    }
}

extension MyRouteView {
    func setGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backBtnAction))
        backBtn.addGestureRecognizer(tapGesture)
        backBtn.isUserInteractionEnabled = true
    }
    
    @objc func backBtnAction(sender: UITapGestureRecognizer) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension MyRouteView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyRouteCollectionViewCell", for: indexPath) as! MyRouteCollectionViewCell
        
        cell.contentView.layer.borderColor = Colors.DESIGN_WHITE.cgColor
        cell.contentView.layer.borderWidth = 1
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.bounds.width - 48, height: 260)
    }
}
