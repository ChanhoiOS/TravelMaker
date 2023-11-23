//
//  MyRecommendListView.swift
//  TravelMaker
//
//  Created by 이찬호 on 11/23/23.
//

import UIKit

class MyRecommendListView: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setCollectionView()
    }

    func setCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UINib(nibName: "MyRecommendCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MyRecommendCollectionViewCell")
    }
 

}

extension MyRecommendListView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyRecommendCollectionViewCell", for: indexPath) as! MyRecommendCollectionViewCell
        
        cell.contentView.layer.borderColor = Colors.DESIGN_WHITE.cgColor
        cell.contentView.layer.borderWidth = 1
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.bounds.width - 48, height: 180)
    }
}
