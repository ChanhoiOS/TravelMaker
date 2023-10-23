//
//  SearchSpaceViewModel.swift
//  TravelMaker
//
//  Created by 이찬호 on 10/23/23.
//

import Foundation
import RxSwift
import RxCocoa

class SearchSpaceViewModel {
    
    static let shared = SearchSpaceViewModel()

    var disposedBag = DisposeBag()

    var requestSelectedData = PublishSubject<[String: Any]>()
    var responseSelectedData = PublishSubject<[String: Any]>()
    
    
    
    init() {
        requestSelectedData.subscribe(onNext: {[weak self] data in
            self?.dataMove(data)
        }).disposed(by: disposedBag)
    }
}

extension SearchSpaceViewModel {
    func dataMove(_ data: [String: Any]) {
        responseSelectedData.onNext(data)
    }
}
