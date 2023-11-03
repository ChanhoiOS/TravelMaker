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
    }
    
    func setCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UINib(nibName: "MyRouteCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MyRouteCollectionViewCell")
    }
}

extension MyRouteView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyRouteCollectionViewCell", for: indexPath) as! MyRouteCollectionViewCell
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.bounds.width / 4, height: self.view.bounds.height / 4)
    }
}
