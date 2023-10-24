//
//  AroundView.swift
//  TravelMaker
//
//  Created by 이찬호 on 2023/09/11.
//

import UIKit
import NMapsMap
import NMapsGeometry
import Then
import SnapKit
import RxSwift
import RxCocoa

class AroundView: UIViewController {
    
    var headerView: UIView!
    var headerLine: UIView!
    
    var naverMapView: NMFMapView?
    
    var disposeBag = DisposeBag()
    
    var latitude = ""
    var longitude = ""
    
    private let pageTitle: UILabel = {
        let label = UILabel()
        label.text = "내 주변의 기록"
        label.textColor = Colors.DESIGN_BLACK
        label.font = UIFont(name: "SUIT-Bold", size: 20)
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        initHeader()
        
        setCoordinate()
        //setMap()
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
}

extension AroundView {
    func setCoordinate() {
        LocationManager.shared.locationSubject
            .bind(onNext: { [weak self] gps in
                let x = gps?.longitude ?? 127.05485569769449
                let y = gps?.latitude ?? 37.50518440330725
                self?.setMap()
                self?.setLocation(x, y)
            }).disposed(by: disposeBag)
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
    
    func setLocation(_ x: Double, _ y: Double) {
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: y, lng: x))
        naverMapView?.moveCamera(cameraUpdate)
        
        let marker = NMFMarker()
                                
        marker.captionRequestedWidth = 60
        marker.position = NMGLatLng(lat: latitude.toDouble() ?? 37.50518440330725, lng: longitude.toDouble() ?? 127.05485569769449)
                                
        let image = UIImage(named: "location_marker")!.resize(newWidth: 48)
        
        marker.iconImage = NMFOverlayImage(image: image)
        marker.mapView = naverMapView
    }
    
}
