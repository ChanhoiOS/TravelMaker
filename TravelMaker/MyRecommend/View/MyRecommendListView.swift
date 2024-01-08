//
//  MyRecommendListView.swift
//  TravelMaker
//
//  Created by 이찬호 on 11/23/23.
//

import UIKit
import Kingfisher
import SafariServices

class MyRecommendListView: BaseViewController {

    @IBOutlet weak var backBtn: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var collectionData: RecommendBookmarkCollectionModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setCollectionView()
        setGesture()
    }
    
    func setCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UINib(nibName: "MyRecommendCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MyRecommendCollectionViewCell")
    }
}

extension MyRecommendListView {
    func setData() {
        let url = Apis.bookmark_recommend
        
        Task {
            do {
                let response = try await AsyncNetworkManager.shared.asyncGet(url, RecommendBookmarkCollectionModel.self)
                collectionData = response
                collectionView.reloadData()
            } catch {
                
            }
        }
    }
}

extension MyRecommendListView {
    func setGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backBtnAction))
        backBtn.addGestureRecognizer(tapGesture)
        backBtn.isUserInteractionEnabled = true
    }
    
    @objc func backBtnAction(sender: UITapGestureRecognizer) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension MyRecommendListView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionData?.data?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyRecommendCollectionViewCell", for: indexPath) as! MyRecommendCollectionViewCell
        
        let backgroundUrl = collectionData?.data?[indexPath.row].recommend?.imageURL ?? ""
        let url = URL(string: backgroundUrl)
        cell.placeImage.kf.setImage(with: url)
        cell.categoryLabel.text = collectionData?.data?[indexPath.row].recommend?.categoryName ?? ""
        cell.placename.text = collectionData?.data?[indexPath.row].recommend?.placeName ?? ""
        cell.address.text = collectionData?.data?[indexPath.row].recommend?.address ?? ""
        
        cell.contentView.layer.borderColor = Colors.DESIGN_WHITE.cgColor
        cell.contentView.layer.borderWidth = 1
        
        cell.recommendId = collectionData?.data?[indexPath.row].recommend?.recommendID ?? 0
        cell.deleteAction = deleteAction(_:)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let url = URL(string: collectionData?.data?[indexPath.row].recommend?.detailURL ?? "www.apple.com") else { return }

        selectDetail(collectionData?.data?[indexPath.row].recommend)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.bounds.width - 48, height: 180)
    }
}

extension MyRecommendListView {
    func deleteAction(_ recommendId: Int) {
        var paramDic = [String: Any]()
        paramDic["recommend_id"] = recommendId
        
        Task {
            do {
                let response = try await AsyncNetworkManager.shared.asyncDelete(Apis.bookmark_delete, paramDic, RecommendBookmarkDeleteModel.self)
                
                if let message = response.message {
                    if message == "성공" {
                        setData()
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateRecommend"), object: nil, userInfo: nil)
                    }
                }
            } catch {
                
            }
        }
    }
}

extension MyRecommendListView: SFSafariViewControllerDelegate {
    func selectDetail(_ detailData: RecommendCollection?) {
        let alert = UIAlertController(title: "맵 선택하기", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "애플맵", style: .default) { action in
            let lat = detailData?.latitude ?? ""
            let lon = detailData?.longitude ?? ""
            let placeName = detailData?.placeName ?? ""
            let address = detailData?.address ?? ""
            
            let appleUrl = "https://maps.apple.com/?" + "address=" + address + "&ll=" + lat + "," + lon + "&q=" + placeName
            guard let url = URL(string: appleUrl) else { return }
            
            let safariViewController = SFSafariViewController(url: url)
            safariViewController.delegate = self
            self.present(safariViewController, animated: true) {
                NotificationCenter.default.post(name: Notification.Name("transferIndex"), object: 3)
            }
        })
        
        alert.addAction(UIAlertAction(title: "카카오맵", style: .default) { action in
            guard let url = URL(string: detailData?.detailURL ?? "www.apple.com") else { return }
            
            let safariViewController = SFSafariViewController(url: url)
            safariViewController.delegate = self
            self.present(safariViewController, animated: true)
        })
        self.present(alert, animated: true, completion: nil)
    }
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        NotificationCenter.default.post(name: Notification.Name("transferIndex"), object: 3)
    }
}
