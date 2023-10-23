//
//  RegisterNearMeModel.swift
//  TravelMaker
//
//  Created by 이찬호 on 10/23/23.
//

import Foundation

struct RequestRegisterNearMeModel {
    let content: String
    let placeName: String
    let dateTime: String
    let latitude: Double
    let longitude: Double
    let imageFiles: [Data]?
    let address: String
    let categoryName: String
    let starRating: Double
}
