//
//  MySpaceListView.swift
//  TravelMaker
//
//  Created by 이찬호 on 1/3/24.
//

import UIKit
import Kingfisher

class MySpaceListView: BaseViewController {

    @IBOutlet weak var backBtn: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var collectionData: MySpaceBookmarkCollectionModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setCollectionView()
        setGesture()
    }
    
    func setCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UINib(nibName: "MySpaceCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MySpaceCollectionViewCell")
    }
}

extension MySpaceListView {
    func setData() {
        let url = Apis.nearby_bookmark_all
        
        Task {
            do {
                let response = try await AsyncNetworkManager.shared.asyncGet(url, MySpaceBookmarkCollectionModel.self)
                collectionData = response
                collectionView.reloadData()
            } catch {
                
            }
        }
    }
}

extension MySpaceListView {
    func setGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backBtnAction))
        backBtn.addGestureRecognizer(tapGesture)
        backBtn.isUserInteractionEnabled = true
    }
    
    @objc func backBtnAction(sender: UITapGestureRecognizer) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension MySpaceListView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionData?.data?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MySpaceCollectionViewCell", for: indexPath) as! MySpaceCollectionViewCell
        
        if let backgroundUrl = collectionData?.data?[indexPath.row].nearby?.imgList {
            if backgroundUrl.count > 0 {
                let url = URL(string: backgroundUrl[0])
                cell.placeImage.kf.setImage(with: url)
            }
        }
        
        cell.categoryLabel.text = collectionData?.data?[indexPath.row].nearby?.categoryName ?? ""
        cell.placename.text = collectionData?.data?[indexPath.row].nearby?.placeName ?? ""
        cell.address.text = collectionData?.data?[indexPath.row].nearby?.address ?? ""
        
        cell.contentView.layer.borderColor = Colors.DESIGN_WHITE.cgColor
        cell.contentView.layer.borderWidth = 1
        
        cell.nearbyID = collectionData?.data?[indexPath.row].nearby?.nearbyID ?? 0
        cell.deleteAction = deleteAction(_:)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.bounds.width - 48, height: 180)
    }
}

extension MySpaceListView {
    func deleteAction(_ nearby_id: Int) {
        var paramDic = [String: Any]()
        paramDic["nearby_id"] = nearby_id
        
        Task {
            do {
                let response = try await AsyncNetworkManager.shared.asyncDelete(Apis.nearby_delete_bookmark, paramDic, MySpaceBookmarkDeleteModel.self)
                
                if let message = response.message {
                    if message == "성공" {
                        setData()
                        //NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateRecommend"), object: nil, userInfo: nil)
                    }
                }
            } catch {
                
            }
        }
    }
}

