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
        //setCoordinate()
        setMarker()
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
    
    func setLocation(_ locations: [NMGLatLng]) {
        let bounds = NMGLatLngBounds(latLngs: locations)
        let cameraUpdate = NMFCameraUpdate(fit: bounds, paddingInsets: UIEdgeInsets(top: 100, left: 100, bottom: 200, right: 100))
        naverMapView?.moveCamera(cameraUpdate)
    }
    
    func setMarker() {
        let pathOverlay = NMFPath()
        pathOverlay.color = .clear
        pathOverlay.outlineColor = .clear
        pathOverlay.width = 5
        pathOverlay.patternIcon = NMFOverlayImage(name: "checkCircle")
        pathOverlay.patternInterval = 10
        
        var points: [NMGLatLng] = [NMGLatLng(lat: 37.50518440330725, lng: 127.05485569769449)]
        
        if let details = collectionData?.routeAddress {
            points.removeAll()
            
            for (index , detail) in details.enumerated() {
                let latitude = (detail.latitude as? NSString)?.doubleValue
                let longitude = (detail.longitude as? NSString)?.doubleValue
                
                points.append(NMGLatLng(lat: latitude ?? 37.50518440330725, lng: longitude ?? 127.05485569769449))
                
                DispatchQueue.main.async {
                    var numberView = UIView()
                    var numberLabel = UILabel()
                    
                    let marker = NMFMarker()
                    marker.captionRequestedWidth = 60
                    let markerImage = UIImage(named: "number_\(index + 1)")!.resizeAll(newWidth: 36, newHeight: 36)
                    let resizeImage = markerImage.resizeAll(newWidth: 36, newHeight: 36)
                    marker.iconImage = NMFOverlayImage(image: resizeImage)
                    marker.position = NMGLatLng(lat: latitude ?? 37.50518440330725, lng: longitude ?? 127.05485569769449)
                    marker.mapView = self.naverMapView
                }
            }
            
            pathOverlay.path = NMGLineString(points: points)
            pathOverlay.mapView = naverMapView
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.setLocation(points)
            }
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
