//
//  RegisterNearMeModel.swift
//  TravelMaker
//
//  Created by 이찬호 on 10/23/23.
//

import Foundation

struct RequestRegisterNearMeModel {
    let content: String
    let place_name: String
    let dateTime: String
    let latitude: Double
    let longitude: Double
    let imageFiles: [Data]?
    let address: String
    let category_name: String
    let star_rating: Double
}
