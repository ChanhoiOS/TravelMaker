//
//  CheckRouteView.swift
//  TravelMaker
//
//  Created by 이찬호 on 12/28/23.
//

import UIKit
import NMapsMap
import NMapsGeometry
import Then
import SnapKit
import FloatingPanel

class CheckRouteView: BaseViewController {
    
    var headerView: UIView!
    var headerLine: UIView!
    
    var naverMapView: NMFMapView?
    
    var fpc: FloatingPanelController!
    
    var collectionData: ResponseRegisterRoute?
    
    var screenHeight = 0.0
    var bottomHeight: Double = 0.0
    
    private let pageTitle: UILabel = {
        let label = UILabel()
        label.text = "장소 확인"
        label.textColor = Colors.DESIGN_BLACK
        label.font = UIFont(name: "SUIT-Bold", size: 20)
        return label
    }()
    
    private let backBtn: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "detail_backBtn.png")
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initHeader()
        setMap()
        setCoordinate()
        setGesture()
        
        screenHeight = UIScreen.main.bounds.size.height
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.setFloatingPanel()
        }
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
            make.left.equalToSuperview().offset(24)
            make.height.width.equalTo(32)
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
}

extension CheckRouteView: FloatingPanelControllerDelegate {
    func setFloatingPanel() {
        let count = collectionData?.routeAddress?.count ?? 0
        
        if count == 1 {
            bottomHeight = screenHeight - Double(160)
        } else if count == 2 {
            bottomHeight = screenHeight - Double(280)
        } else {
            bottomHeight = screenHeight - Double(100 * count)
        }
        
        fpc = FloatingPanelController(delegate: self)
                
        let vc = RouteModal(nibName: "RouteModal", bundle: nil)
        vc.model = collectionData
        fpc.changePanelStyle() // panel 스타일 변경 (대신 bar UI가 사라지므로 따로 넣어주어야함)
        fpc.delegate = self
        fpc.set(contentViewController: vc) // floating panel에 삽입할 것
        fpc.track(scrollView: vc.tableView)
        fpc.addPanel(toParent: self) // fpc를 관리하는 UIViewController
        fpc.layout = MyFloatingPanelLayout(bottomHeight)
        fpc.invalidateLayout() // if needed
        
        fpc.contentMode = .fitToBounds
    }
}

extension CheckRouteView: NMFMapViewTouchDelegate {
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
                    make.top.equalTo(headerLine.snp.bottom).offset(0)
                    make.left.right.equalToSuperview()
                    make.bottom.equalToSuperview()
                }
            }
    }
    
    func setLocation(_ x: Double, _ y: Double) {
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: y, lng: x))
        naverMapView?.moveCamera(cameraUpdate)
        
        setMarker()
    }
    
    func setMarker() {
        let pathOverlay = NMFPath()
        pathOverlay.color = .red            // pathOverlay의 색
        pathOverlay.outlineColor = .blue    // pathOverlay 테두리 색
        pathOverlay.width = 10              // pathOverlay 두께
        
        var points: [NMGLatLng] = [NMGLatLng(lat: 37.50518440330725, lng: 127.05485569769449)]
        
        if let details = collectionData?.routeAddress {
            points.removeAll()
            
            for (_ , detail) in details.enumerated() {
                let latitude = (detail.latitude as? NSString)?.doubleValue
                let longitude = (detail.longitude as? NSString)?.doubleValue
                let coordinate = CLLocationCoordinate2D(latitude: latitude ?? 37.50518440330725, longitude: longitude ?? 127.05485569769449)
                
                points.append(NMGLatLng(lat: latitude ?? 37.50518440330725, lng: longitude ?? 127.05485569769449))
            }
            print("points: ", points)
            pathOverlay.path = NMGLineString(points: points)
            
            pathOverlay.mapView = naverMapView
//                let marker = NMFMarker()
//                
//                marker.captionRequestedWidth = 60
//                                
//                if let imageUrls = detail.imgList {
//                    if imageUrls.count > 0 {
//                        DispatchQueue.global().async {
//                            let url = URL(string: imageUrls[0])!
//                            let latitude = (detail.latitude as? NSString)?.doubleValue
//                            let longitude = (detail.longitude as? NSString)?.doubleValue
//                            
//                            if let data = try? Data(contentsOf: url) {
//                                if let image = UIImage(data: data) {
//                                    DispatchQueue.main.async {
//                                        let resizeImage = image.resizeAll(newWidth: 36, newHeight: 36)
//                                        marker.iconImage = NMFOverlayImage(image: resizeImage)
//                                        marker.position = NMGLatLng(lat: latitude ?? 37.50518440330725, lng: longitude ?? 127.05485569769449)
//                                        marker.mapView = self.naverMapView
//                                        
//                                        marker.touchHandler = { (overlay: NMFOverlay) -> Bool in
//                                            //self.markerAction(index, detail, image)
//                                            self.naverMapView?.moveCamera(NMFCameraUpdate(scrollTo: NMGLatLng(lat: latitude ?? 37.50518440330725, lng: longitude ?? 127.05485569769449)))
//                                            return true
//                                        }
//                                    }
//                                }
//                            }
//                        }
//                    }
//                }
        //    }
        }
    }
}

extension CheckRouteView {
    func setGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backBtnAction))
        backBtn.addGestureRecognizer(tapGesture)
        backBtn.isUserInteractionEnabled = true
    }
    
    @objc func backBtnAction(sender: UITapGestureRecognizer) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension FloatingPanelController {
    func changePanelStyle() {
        let appearance = SurfaceAppearance()
        let shadow = SurfaceAppearance.Shadow()
        shadow.color = UIColor.black
        shadow.offset = CGSize(width: 0, height: -4.0)
        shadow.opacity = 0.15
        shadow.radius = 2
        appearance.shadows = [shadow]
        appearance.cornerRadius = 15.0
        appearance.backgroundColor = .clear
        appearance.borderColor = .clear
        appearance.borderWidth = 0

        surfaceView.grabberHandle.isHidden = true
        surfaceView.appearance = appearance
    }
}

class MyFloatingPanelLayout: FloatingPanelLayout {
    
    var height = 0.0
    
    init(_ bottomHeight: Double) {
        height = bottomHeight
    }

    var position: FloatingPanelPosition {
        return .bottom
    }

    var initialState: FloatingPanelState {
        return .half
    }
    
    var anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring] {
        return [
            .full: FloatingPanelLayoutAnchor(absoluteInset: height, edge: .top, referenceGuide: .safeArea),
            .half: FloatingPanelLayoutAnchor(absoluteInset: 24.0, edge: .bottom, referenceGuide: .safeArea),
        ]
    }
}
