//
//  ResponseRegisterRouteModel.swift
//  TravelMaker
//
//  Created by 이찬호 on 12/26/23.
//

import Foundation

// MARK: - ResponseRegisterRouteModel
struct ResponseRegisterRouteModel: Codable {
    let data: [ResponseRegisterRoute]?
}

// MARK: - Datum
struct ResponseRegisterRoute: Codable {
    let routeInfoID: Int?
    let title, startDate, endDate: String?
    let fileURL: String?
    let createdAt, updateAt: String?
    let routeAddress: [RouteAddress]?
    let user: UserInfo?

    enum CodingKeys: String, CodingKey {
        case routeInfoID = "routeInfoId"
        case title, startDate, endDate
        case fileURL = "fileUrl"
        case createdAt, updateAt, routeAddress, user
    }
}

// MARK: - RouteAddress
struct RouteAddress: Codable {
    let routeAddressID, addressOrder: Int?
    let addressName, addressDetail, latitude, longitude: String?
    let createdAt, updateAt: String?

    enum CodingKeys: String, CodingKey {
        case routeAddressID = "routeAddressId"
        case addressOrder, addressName, addressDetail, latitude, longitude, createdAt, updateAt
    }
}
