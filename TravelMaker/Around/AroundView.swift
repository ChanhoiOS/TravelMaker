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
import ReactorKit
import Kingfisher

class AroundView: BaseViewController, StoryboardView {
    
    var headerView: UIView!
    var headerLine: UIView!
    
    var naverMapView: NMFMapView?
    
    let reactor = AroundViewReactor()
    var aroundAllResult: ResponseAroundModel?
    
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
    func bind(reactor: AroundViewReactor) {
        reactor.action.onNext(.getAllAroundData(()))
        
        reactor.state
            .map { $0.aroundResult }
            .bind(onNext: {[weak self] result in
                self?.aroundAllResult = result
                if let data = result?.data {
                    self?.setMarker(result!)
                }
            })
            .disposed(by: disposeBag)
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
    }
    
    func setMarker(_ aroundData: ResponseAroundModel) {
        if let details = aroundData.data {
            for detail in details {
                let marker = NMFMarker()
                
                marker.captionRequestedWidth = 60
                
                
                if let imageUrls = detail.imagesPath {
                    if imageUrls.count > 0 {
                        DispatchQueue.global().async {
                            let url = URL(string: Apis.imageUrl + imageUrls[0])!
                            
                            if let data = try? Data(contentsOf: url) {
                                if let image = UIImage(data: data) {
                                    DispatchQueue.main.async {
                                        let resizeImage = image.resizeAll(newWidth: 60, newHeight: 70)
                                        marker.iconImage = NMFOverlayImage(image: resizeImage)
                                        marker.position = NMGLatLng(lat: detail.latitude ?? 37.50518440330725, lng: detail.longitude ?? 127.05485569769449)
                                        marker.mapView = self.naverMapView
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
