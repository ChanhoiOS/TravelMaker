//
//  RequestRegisterRouteModel.swift
//  TravelMaker
//
//  Created by 이찬호 on 12/26/23.
//

import Foundation

struct RequestRegisterRouteModel {
    var imageFiles: [Data]?
    var title: String
    var startDate: String
    var endDate: String
    var routeAddressList: [RequestRegisterRoute]?
    
    init(imageFiles: [Data]?, title: String, startDate: String, endDate: String, routeAddressList: [RequestRegisterRoute]) {
            self.imageFiles = imageFiles
            self.title = title
            self.startDate = startDate
            self.endDate = endDate
            self.routeAddressList = routeAddressList
        }
}

struct RequestRegisterRoute: Codable {
    var addressName, addressDetail: String?
    var latitude, longitude: Double?

    enum CodingKeys: String, CodingKey {
        case addressName = "address_name"
        case addressDetail = "address_detail"
        case latitude, longitude
    }
}
