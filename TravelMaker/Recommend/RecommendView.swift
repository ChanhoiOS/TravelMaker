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
import SafariServices

class RecommendView: UIViewController, NMFMapViewCameraDelegate {
    
    var customView: RecommendSelectView?
    var naverMapView: NMFMapView?
    var bottomSheet: BottomSheetView?
    
    var responseAllModel: ResponseRecommendALLModel?
    var forMapData: [RecommendAllData]?
    var detailData: RecommendAllData?
    
    var tabBarHeight: Int = 83
    
    var markers = [NMFMarker]()
    
    private lazy var restaurantBtn: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "recommend_restaurant_white"), for: .normal)
        button.setTitle("  추천 맛집", for: .normal)
        button.setTitleColor(Colors.RECOMMEND_GRAY, for: .normal)
        button.titleLabel?.font = UIFont(name: "SUIT-Regular", size: 16)
        button.backgroundColor = Colors.RECOMMEND_RED
        button.addTarget(self, action: #selector(recommendRestaurant), for: .touchUpInside)
        button.isSelected = true
        return button
    }()
    
    private lazy var hotpleBtn: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "recommend_hotple_white"), for: .normal)
        button.setTitle("  추천 핫플", for: .normal)
        button.setTitleColor(Colors.RECOMMEND_GRAY, for: .normal)
        button.titleLabel?.font = UIFont(name: "SUIT-Regular", size: 16)
        button.backgroundColor = Colors.RECOMMEND_ORANGE
        button.addTarget(self, action: #selector(recommendHotple), for: .touchUpInside)
        button.isSelected = true
        return button
    }()
    
    private lazy var dormitoryBtn: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "recommend_dormitory_white"), for: .normal)
        button.setTitle("  추천 숙소", for: .normal)
        button.setTitleColor(Colors.RECOMMEND_GRAY, for: .normal)
        button.titleLabel?.font = UIFont(name: "SUIT-Regular", size: 16)
        button.backgroundColor = Colors.RECOMMEND_PURPLE
        button.addTarget(self, action: #selector(recommendDormitory), for: .touchUpInside)
        button.isSelected = true
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setMap()
        setCoordinate()
        setTopBtn()
        
        setData()
        
        getHeight()
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
    
    func getHeight() {
        tabBarHeight = Int(self.tabBarController?.tabBar.frame.height ?? 49.0)
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
                responseAllModel = try await AsyncNetworkManager.shared.asyncGet(Apis.recommend_all)
            } catch {
                
            }
            
            setBottomSheet(responseAllModel)
            setCategory(true, true, true)
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
        
        setCategory(restaurantBtn.isSelected, hotpleBtn.isSelected, dormitoryBtn.isSelected)
    }
    
    @objc func recommendHotple() {
        hotpleBtn.isSelected.toggle()
            
        let color = hotpleBtn.isSelected ? Colors.RECOMMEND_ORANGE : .white
        let image = hotpleBtn.isSelected ? UIImage(named: "recommend_hotple_white") : UIImage(named: "recommend_hotple")
        hotpleBtn.backgroundColor = color
        hotpleBtn.setImage(image, for: .normal)
        
        setCategory(restaurantBtn.isSelected, hotpleBtn.isSelected, dormitoryBtn.isSelected)
    }
    
    @objc func recommendDormitory() {
        dormitoryBtn.isSelected.toggle()
            
        let color = dormitoryBtn.isSelected ? Colors.RECOMMEND_PURPLE : .white
        let image = dormitoryBtn.isSelected ? UIImage(named: "recommend_dormitory_white") : UIImage(named: "recommend_dormitory")
        dormitoryBtn.backgroundColor = color
        dormitoryBtn.setImage(image, for: .normal)
        
        setCategory(restaurantBtn.isSelected, hotpleBtn.isSelected, dormitoryBtn.isSelected)
    }
    
    func setCategory(_ restaurant: Bool, _ hotple: Bool, _ dormitory: Bool) {
        for i in 0..<markers.count {
            markers[i].mapView = nil
        }
        
        if restaurant && hotple && dormitory {
            forMapData = responseAllModel?.data
        } else if restaurant && hotple && !dormitory {
            forMapData = responseAllModel?.data?.filter { $0.category == .food || $0.category == .popular }
        } else if restaurant && !hotple && dormitory {
            forMapData = responseAllModel?.data?.filter { $0.category == .food || $0.category == .accommodation }
        } else if restaurant && !hotple && !dormitory {
            forMapData = responseAllModel?.data?.filter { $0.category == .food }
        } else if !restaurant && hotple && dormitory {
            forMapData = responseAllModel?.data?.filter { $0.category == .popular || $0.category == .accommodation }
        } else if !restaurant && hotple && !dormitory {
            forMapData = responseAllModel?.data?.filter { $0.category == .popular }
        } else if !restaurant && !hotple && dormitory {
            forMapData = responseAllModel?.data?.filter { $0.category == .accommodation }
        } else {
            forMapData = [RecommendAllData]()
        }
        
        setMarker()
    }
    
    func setMarker() {
        if let details = forMapData {
            for (index, detail) in details.enumerated() {
                let marker = NMFMarker()
                markers.append(marker)
                
                markers[index].captionRequestedWidth = 60
                
                if let imageUrls = detail.imageURL {
                    if imageUrls.count > 0 {
                        DispatchQueue.global().async {
                            let latitude = (detail.latitude as? NSString)?.doubleValue
                            let longitude = (detail.longitude as? NSString)?.doubleValue
                            
                            var imageName = "recommend_red_marker"
                            
                            if detail.category == .food {
                                imageName = "recommend_red_marker"
                            } else if detail.category == .popular {
                                imageName = "recommend_orange_marker"
                            } else if detail.category == .accommodation {
                                imageName = "recommend_purple_marker"
                            }
                            
                            let image = UIImage(named: imageName)!
                            DispatchQueue.main.async {
                                let resizeImage = image.resizeAll(newWidth: 48, newHeight: 48)
                                self.markers[index].iconImage = NMFOverlayImage(image: resizeImage)
                                self.markers[index].position = NMGLatLng(lat: latitude ?? 37.50518440330725, lng: longitude ?? 127.05485569769449)
                                self.markers[index].mapView = self.naverMapView
                                
                                self.markers[index].touchHandler = { (overlay: NMFOverlay) -> Bool in
                                    self.markerAction(index, detail)
                                    
                                    let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: latitude ?? 37.50518440330725, lng: longitude ?? 127.05485569769449))
                                    cameraUpdate.animation = .easeOut
                                    self.naverMapView?.moveCamera(cameraUpdate)
                                    return true
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func markerAction(_ index: Int, _ detail: RecommendAllData) {
        if customView != nil {
            customView?.removeFromSuperview()
        }
        
        detailData = detail
        
        customView = RecommendSelectView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), detail)
            .then {
                self.view.addSubview($0)
                
                $0.snp.makeConstraints { make in
                    make.bottom.equalToSuperview().offset(-64 - tabBarHeight)
                    make.left.equalToSuperview().offset(24)
                    make.right.equalToSuperview().offset(-24)
                    make.height.equalTo(184)
                }
                
                self.view.insertSubview($0, belowSubview: bottomSheet ?? UIView())
                
                $0.bringSubviewToFront(naverMapView!)
        }
            .then {
                let button = UIButton()
                $0.addSubview(button)
                
                button.snp.makeConstraints { make in
                    make.edges.equalToSuperview()
                }
                
                button.addTarget(self, action: #selector(selectDetail), for: .touchUpInside)
            }
    }
}

extension RecommendView: SelectRecommendData {
    func selectSpace(_ data: RecommendAllData?) {
        let latitude = (data?.latitude as? NSString)?.doubleValue ?? 37.50518440330725
        let longitude = (data?.longitude as? NSString)?.doubleValue ?? 127.05485569769449
        
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: latitude, lng: longitude))
        cameraUpdate.animation = .easeOut
        naverMapView?.moveCamera(cameraUpdate)
    }
}

extension RecommendView: SFSafariViewControllerDelegate {
    @objc func selectDetail() {
        guard let url = URL(string: detailData?.detailURL ?? "www.apple.com") else { return }

        let safariViewController = SFSafariViewController(url: url)
        safariViewController.delegate = self
        self.present(safariViewController, animated: true)
    }
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        NotificationCenter.default.post(name: Notification.Name("transferIndex"), object: nil)
    }
    
}
