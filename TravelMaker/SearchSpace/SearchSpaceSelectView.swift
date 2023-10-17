//
//  SearchSpaceSelectView.swift
//  TravelMaker
//
//  Created by 이찬호 on 2023/10/17.
//

import UIKit
import NMapsMap
import NMapsGeometry
import Then
import SnapKit

class SearchSpaceSelectView: UIViewController {
    var headerView: UIView!
    var headerLine: UIView!
    var middleLine: UIView!
    
    var naverMapView: NMFMapView?
    
    var latitude = ""
    var longitude = ""
    
    private let backBtn: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "header_back_btn.png")
        return imageView
    }()
    
    private let pageTitle: UILabel = {
        let label = UILabel()
        label.text = "장소 확인"
        label.textColor = Colors.DESIGN_BLACK
        label.font = UIFont(name: "SUIT-Bold", size: 20)
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initHeader()
        setMap()
        setLocation()
    }

    func initHeader() {
        headerView = UIView()
            .then {
                self.view.addSubview($0)
                $0.snp.makeConstraints { make in
                    make.top.equalToSuperview().offset(44)
                    make.left.right.equalToSuperview()
                    make.height.equalTo(59)
                }
            }
        
        headerView.addSubview(backBtn)
        backBtn.snp.makeConstraints { make in
            make.left.equalTo(24)
            make.width.height.equalTo(32)
            make.centerY.equalToSuperview()
        }
        
        headerView.addSubview(pageTitle)
        pageTitle.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        headerLine = UIView()
            .then {
                self.view.addSubview($0)
                $0.backgroundColor = Colors.GRAY_LINE
                $0.snp.makeConstraints { make in
                    make.left.right.equalToSuperview()
                    make.bottom.equalTo(headerView.snp.bottom).offset(0)
                    make.height.equalTo(0.8)
                }
            }
    }
    
    func setMap() {
        naverMapView = NMFMapView()
            .then {
                self.view.addSubview($0)
                
                $0.snp.makeConstraints { make in
                    make.top.equalTo(headerLine.snp.bottom).offset(0)
                    make.left.right.equalToSuperview()
                    make.bottom.equalToSuperview()
                }
            }
    }
    
    func setLocation() {
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: latitude.toDouble() ?? 37.50518440330725, lng: longitude.toDouble() ?? 127.05485569769449))
        naverMapView?.moveCamera(cameraUpdate)
        
        let marker = NMFMarker()
                                
        marker.captionRequestedWidth = 60
        marker.position = NMGLatLng(lat: latitude.toDouble() ?? 37.50518440330725, lng: longitude.toDouble() ?? 127.05485569769449)
                                
        let image = UIImage(named: "location_marker")!.resize(newWidth: 48)
        
        marker.iconImage = NMFOverlayImage(image: image)
        marker.mapView = self.naverMapView
    }
    
}

extension SearchSpaceSelectView {
    func setGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backBtnAction))
        backBtn.addGestureRecognizer(tapGesture)
        backBtn.isUserInteractionEnabled = true
    }
    
    @objc func backBtnAction(sender: UITapGestureRecognizer) {
        self.navigationController?.popViewController(animated: true)
    }
}
