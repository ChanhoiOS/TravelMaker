//
//  AroundViewReactor.swift
//  TravelMaker
//
//  Created by 이찬호 on 10/24/23.
//

import Foundation
import ReactorKit
import RxSwift
import RxCocoa
import Alamofire

class AroundViewReactor: Reactor {
    let initialState = State()
    var disposeBag = DisposeBag()
    
    enum Action {
        case getAllAroundData(Void)
    }
    
    enum Mutation {
        case setAllAroundData(ResponseAroundModel?)
    }
    
    struct State {
        var aroundResult: ResponseAroundModel?
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .getAllAroundData:
            return Observable.concat([
                self.getAllData()
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .setAllAroundData(let data):
            state.aroundResult = data
        }
        
        return state
    }
}


extension AroundViewReactor {
    func getAllData() -> Observable<Mutation> {
        var headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        
        if let accessToken = SessionManager.shared.accessToken {
            headers = ["Authorization": accessToken]
        }
        
        return Observable<Mutation>.create { observer -> Disposable in
            AF.request(Apis.getAround,
                       method: .get,
                       parameters: nil,
                       encoding: URLEncoding.queryString,
                       headers: headers)
            .responseDecodable(of: ResponseAroundModel.self) { response in
                switch response.result {
                case .success(let data):
                    observer.onNext(.setAllAroundData(data))
                case .failure(let error):
                    observer.onError(error)
                }
            }
            
            return Disposables.create()
        }
    }
}
