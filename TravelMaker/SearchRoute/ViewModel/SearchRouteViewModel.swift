//
//  SearchRouteViewModel.swift
//  TravelMaker
//
//  Created by 이찬호 on 11/19/23.
//

import Foundation
import RxSwift
import RxCocoa

class SearchRouteViewModel {
    
    static let shared = SearchRouteViewModel()

    var disposedBag = DisposeBag()

    var requestSelectedData = PublishSubject<[String: Any]>()
    var responseSelectedData = PublishSubject<[String: Any]>()
    
    init() {
        requestSelectedData.subscribe(onNext: {[weak self] data in
            self?.dataMove(data)
        }).disposed(by: disposedBag)
    }
}

extension SearchRouteViewModel {
    func dataMove(_ data: [String: Any]) {
        responseSelectedData.onNext(data)
    }
}
