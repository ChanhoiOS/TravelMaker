//
//  SearchSpaceViewModel.swift
//  TravelMaker
//
//  Created by 이찬호 on 2023/10/13.
//

import Foundation
import RxSwift

class SearchSpaceViewModel {
    var wishItem: [String]

        init() {
            // dummy data
            wishItem = ["MacBook M1 Pro", "iPhone 13 Pro max", "iPad Pro 15"]
        }
        
        func getCellData() -> Observable<[String]> {
            return Observable.of(wishItem)
        }
}
