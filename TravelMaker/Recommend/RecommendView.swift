//
//  RecommendView.swift
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

class RecommendView: UIViewController, NMFMapViewCameraDelegate {
    
    var naverMapView: NMFMapView?
    var bottomSheet: BottomSheetView?
    
    var responseAllModel: ResponseRecommendALLModel?
    
    private lazy var restaurantBtn: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "recommend_restaurant"), for: .normal)
        button.setTitle("  추천 맛집", for: .normal)
        button.setTitleColor(Colors.RECOMMEND_GRAY, for: .normal)
        button.titleLabel?.font = UIFont(name: "SUIT-Regular", size: 16)
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(recommendRestaurant), for: .touchUpInside)
        return button
    }()
    
    private lazy var hotpleBtn: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "recommend_hotple"), for: .normal)
        button.setTitle("  추천 핫플", for: .normal)
        button.setTitleColor(Colors.RECOMMEND_GRAY, for: .normal)
        button.titleLabel?.font = UIFont(name: "SUIT-Regular", size: 16)
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(recommendHotple), for: .touchUpInside)
        return button
    }()
    
    private lazy var dormitoryBtn: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "recommend_dormitory"), for: .normal)
        button.setTitle("  추천 숙소", for: .normal)
        button.setTitleColor(Colors.RECOMMEND_GRAY, for: .normal)
        button.titleLabel?.font = UIFont(name: "SUIT-Regular", size: 16)
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(recommendDormitory), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setMap()
        setCoordinate()
        setTopBtn()
        
        setData()
    }
    
    func setTopBtn() {
        self.view.addSubview(restaurantBtn)
        
        restaurantBtn.layer.cornerRadius = 16
        
        restaurantBtn.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(64)
            make.left.equalToSuperview().offset(24)
            make.width.equalTo(102)
            make.height.equalTo(38)
        }
        
        self.view.addSubview(hotpleBtn)
        
        hotpleBtn.layer.cornerRadius = 16
        
        hotpleBtn.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(64)
            make.left.equalTo(restaurantBtn.snp.right).offset(8)
            make.width.equalTo(102)
            make.height.equalTo(38)
        }
        
        self.view.addSubview(dormitoryBtn)
        
        dormitoryBtn.layer.cornerRadius = 16
        
        dormitoryBtn.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(64)
            make.left.equalTo(hotpleBtn.snp.right).offset(8)
            make.width.equalTo(102)
            make.height.equalTo(38)
        }
    }
    
    func setBottomSheet(_ data: ResponseRecommendALLModel?) {
        bottomSheet = BottomSheetView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), data)
            .then {
                self.view.addSubview($0)
                $0.delegate = self
                
                $0.snp.makeConstraints { make in
                    make.edges.equalToSuperview()
                }
            }
    }
}

extension RecommendView: NMFMapViewTouchDelegate {
    func setCoordinate() {
        let gpsDisposable = LocationManager.shared.locationSubject
            .subscribe(onNext: { [weak self] gps in
                let x = gps?.longitude ?? 127.05485569769449
                let y = gps?.latitude ?? 37.50518440330725
                self?.setLocation(x, y)
            }, onCompleted: {
                print("onComplete")
            }) {
                print("disposed")
            }
        
        gpsDisposable.dispose()
    }
    
    func setMap() {
        naverMapView = NMFMapView()
            .then {
                self.view.addSubview($0)
                
                $0.touchDelegate = self
                
                $0.snp.makeConstraints { make in
                    make.top.left.right.equalToSuperview()
                    make.bottom.equalToSuperview()
                }
            }
        
        naverMapView?.addCameraDelegate(delegate: self)
    }
    
    func setLocation(_ x: Double, _ y: Double) {
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: y, lng: x))
        naverMapView?.moveCamera(cameraUpdate)
    }
    
    func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
        bottomSheet?.mode = .tip
    }
}

extension RecommendView {
    func setData() {
        Task {
            do {
                responseAllModel = try await AsyncNetworkManager.shared.asyncGet(Apis.recommendAll)
            } catch {
                
            }
            
            setBottomSheet(responseAllModel)
        }
    }
}

extension RecommendView {
    @objc func recommendRestaurant() {
        restaurantBtn.isSelected.toggle()
            
        let color = restaurantBtn.isSelected ? Colors.RECOMMEND_RED : .white
        let image = restaurantBtn.isSelected ? UIImage(named: "recommend_restaurant_white") : UIImage(named: "recommend_restaurant")
        restaurantBtn.backgroundColor = color
        restaurantBtn.setImage(image, for: .normal)
    }
    
    @objc func recommendHotple() {
        hotpleBtn.isSelected.toggle()
            
        let color = hotpleBtn.isSelected ? Colors.RECOMMEND_ORANGE : .white
        let image = hotpleBtn.isSelected ? UIImage(named: "recommend_hotple_white") : UIImage(named: "recommend_hotple")
        hotpleBtn.backgroundColor = color
        hotpleBtn.setImage(image, for: .normal)
    }
    
    @objc func recommendDormitory() {
        dormitoryBtn.isSelected.toggle()
            
        let color = dormitoryBtn.isSelected ? Colors.RECOMMEND_PURPLE : .white
        let image = dormitoryBtn.isSelected ? UIImage(named: "recommend_dormitory_white") : UIImage(named: "recommend_dormitory")
        dormitoryBtn.backgroundColor = color
        dormitoryBtn.setImage(image, for: .normal)
    }
}

extension RecommendView: SelectRecommendData {
    func selectSpace(_ data: RecommendAllData?) {
        let latitude = data?.latitude ?? 37.50518440330725
        let longitude = data?.longitude ?? 127.05485569769449
        
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: latitude, lng: longitude))
        cameraUpdate.animation = .easeOut
        naverMapView?.moveCamera(cameraUpdate)
    }
}
