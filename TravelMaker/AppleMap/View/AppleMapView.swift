//
//  AppleMapView.swift
//  TravelMaker
//
//  Created by 이찬호 on 1/8/24.
//

import UIKit
import MapKit
import SnapKit
import Then

class AppleMapView: UIViewController {

    let mapView = MKMapView()
    var header: CommonHeader!
    var detailData: RecommendAllData?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        setMapkit()
    }
    
    func setUI() {
        header = CommonHeaderBuilder()
            .setHeaderTitle(detailData?.placeName ?? "")
            .setHeaderType(.normal)
            .build()
            .then {
                self.view.addSubview($0)
                $0.snp.makeConstraints { make in
                    make.top.equalToSuperview().offset(self.view.topSafeAreaHeight)
                    make.left.right.equalToSuperview()
                    make.height.equalTo(84)
                }
            }
    }
    
    func setMapkit() {
        self.view.addSubview(mapView)
        mapView.snp.makeConstraints { make in
            make.top.equalTo(header.snp.bottom).offset(0)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(0)
        }
        
        if #available(iOS 16.0, *) {
            mapView.preferredConfiguration = MKStandardMapConfiguration()
        } else {
            mapView.mapType = MKMapType.standard
        }
        
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        mapView.isPitchEnabled = true
        mapView.isRotateEnabled = true
        mapView.showsCompass = true
        mapView.showsScale = true
        mapView.showsUserLocation = true
        
        let latitude = (detailData?.latitude as? NSString)?.doubleValue ?? 37.50518440330725
        let longitude = (detailData?.longitude as? NSString)?.doubleValue ?? 127.05485569769449
        
        let center = CLLocationCoordinate2D(latitude: latitude,
                                            longitude: longitude)

        // center를 중심으로 지정한 미터(m)만큼의 영역을 보여줌
        let region = MKCoordinateRegion(center: center,
                                        latitudinalMeters: 500,
                                        longitudinalMeters: 500)

        mapView.setRegion(region, animated: true)
        
        createAnnotaion(latitude, longitude)
    }

    func createAnnotaion(_ lat: Double, _ lon: Double) {
        let annotation = MKPointAnnotation()
        
        annotation.coordinate = CLLocationCoordinate2D(latitude: lat,
                                                       longitude: lon)
        
        annotation.title = detailData?.placeName ?? ""
        annotation.subtitle = detailData?.categoryName ?? ""
        
        // 맵뷰에 Annotaion 추가
        mapView.addAnnotation(annotation)
    }
}
