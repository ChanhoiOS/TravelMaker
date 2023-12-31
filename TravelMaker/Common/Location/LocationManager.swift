//
//  LocationManager.swift
//  TravelMaker
//
//  Created by 이찬호 on 2023/10/16.
//

import Foundation
import RxSwift
import RxCocoa
import RxCoreLocation
import CoreLocation

class LocationManager {
    static let shared = LocationManager()
    private let disposeBag = DisposeBag()
    
    let locationSubject = BehaviorSubject<CLLocationCoordinate2D?>(value: nil)
    
    private let locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.distanceFilter = kCLDistanceFilterNone
        return manager
    }()
    
    private init() {
        self.locationManager.rx.didUpdateLocations
            .compactMap(\.locations.last?.coordinate)
            .bind(onNext:
                    self.locationSubject.onNext(_:)
            )
            .disposed(by: self.disposeBag)
        
        self.locationManager.startUpdatingLocation() // 이미 권한을 허용한 경우 케이스 대비
    }
    
    func requestLocation() -> Observable<CLAuthorizationStatus> {
        return Observable<CLAuthorizationStatus>
            .deferred { [weak self] in
                guard let auth = self else { return .empty()}
                auth.locationManager.requestWhenInUseAuthorization()
                return auth.locationManager.rx.didChangeAuthorization
                    .map { $1 }
                    .filter { $0 != .notDetermined }
                    .do(onNext: { _ in auth.locationManager.startUpdatingLocation()})
                        .take(1)
        }
    }
    
    func distance(_ from: CLLocationCoordinate2D?, _ latitude: String?, _ longitude: String?) -> CLLocationDistance {
        let fromLatitude = from?.latitude ?? 37.542786501548630000
        let fromLongitude = from?.longitude ?? 126.951350477023310000
        let toLatitude = Double(latitude ?? "37.542786501548630000") ?? 37.542786501548630000
        let toLongittude = Double(longitude ?? "126.951350477023310000") ?? 126.951350477023310000
        
        let coordinate = CLLocation(latitude: fromLatitude, longitude: fromLongitude)
        let to = CLLocation(latitude: toLatitude, longitude: toLongittude)
        return coordinate.distance(from: to)
    }
}
