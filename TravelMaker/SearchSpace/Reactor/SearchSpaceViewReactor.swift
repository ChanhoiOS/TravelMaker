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

class SearchSpaceViewReactor: Reactor {
    let initialState = State()
    
    enum Action {
        case search(String?)
    }
        
    enum Mutation {
        case setSearch(SearchSpaceModel?)
    }
        
    struct State {
    
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .search(let text):
            return Observable.concat([
                self.searchSpace(text ?? "")
            ])
        }
    }
}

extension SearchSpaceViewReactor {
    func getCommonHeaders() -> HTTPHeaders {
        let headers: HTTPHeaders = [
            "Authorization": "KakaoAK 6c8efb7c415446c40b0a1ffb43babe9a",
            "Content-Type": "application/json"
        ]
        
        return headers
    }
    
    
    func searchSpace(_ text: String) -> Observable<Mutation> {
        let url = "https://dapi.kakao.com/v2/local/search/keyword.json"
        var param = [String: Any]()
        param["query"] = "시그니엘 서울"
        param["x"] = "37.514322572335935"
        param["y"] = "127.06283102249932"
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
                    observer.onNext(.setSearch(data))
                case .failure(let error):
                    observer.onError(error)
                }
            }
            
            return Disposables.create()
        }
    }
}
