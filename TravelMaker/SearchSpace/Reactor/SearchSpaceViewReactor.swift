//
//  SearchSpaceViewModel.swift
//  TravelMaker
//
//  Created by 이찬호 on 2023/10/13.
//

import Foundation
import RxSwift
import ReactorKit
import RxCocoa
import Alamofire
import CoreLocation

class SearchSpaceViewReactor: Reactor {
    let initialState = State()
    var disposeBag = DisposeBag()
    
    enum Action {
        case location(Void)
        case search(String?, Double, Double)
    }
        
    enum Mutation {
        case setLocation(CLLocationCoordinate2D?)
        case setResult(SearchSpaceModel?)
    }
        
    struct State {
        var locationResult: CLLocationCoordinate2D?
        var searchResult: SearchSpaceModel?
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .location:
            return Observable.concat([
                self.getLocation()
            ])
            
        case .search(let text, let x, let y):
            return Observable.concat([
                self.searchSpace(text ?? "", x, y)
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .setLocation(let location):
            state.locationResult = location
        case .setResult(let data):
            state.searchResult = data
        }
        
        return state
    }
}

extension SearchSpaceViewReactor {
    func getCommonHeaders() -> HTTPHeaders {
        let headers: HTTPHeaders = [
            "Authorization": "KakaoAK 7caf64fa5306dcc269e66c45c0b9fb78",
            "Content-Type": "application/json"
        ]
        
        return headers
    }
    
    
    func searchSpace(_ text: String, _ x: Double, _ y: Double) -> Observable<Mutation> {
        let url = "https://dapi.kakao.com/v2/local/search/keyword.json"
        var param = [String: Any]()
        param["query"] = text
        param["x"] = x
        param["y"] = y
        param["page"] = 1
        param["size"] = 15
        param["sort"] = "accuracy"
        
        return Observable<Mutation>.create { observer -> Disposable in
            AF.request(url,
                       method: .get,
                       parameters: param,
                       encoding: URLEncoding.queryString,
                       headers: self.getCommonHeaders())
            .responseDecodable(of: SearchSpaceModel.self) { response in
                switch response.result {
                case .success(let data):
                    observer.onNext(.setResult(data))
                case .failure(let error):
                    observer.onError(error)
                }
            }
            
            return Disposables.create()
        }
    }
}

extension SearchSpaceViewReactor {
    func getLocation() -> Observable<Mutation> {
        return Observable<Mutation>.create { observer -> Disposable in
            
            LocationManager.shared.locationSubject
                .compactMap { $0 }
                .bind { location in
                    observer.onNext(.setLocation(location))
                }
            }
            
        }
}
