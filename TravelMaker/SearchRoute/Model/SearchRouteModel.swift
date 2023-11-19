//
//  SearchRouteModel.swift
//  TravelMaker
//
//  Created by 이찬호 on 11/19/23.
//

import Foundation

// MARK: - SearchSpaceModel
struct SearchRouteModel: Codable {
    let documents: [RouteDocument]?
    let meta: RouteMeta?
}

// MARK: - Document
struct RouteDocument: Codable {
    let addressName, categoryGroupCode, categoryGroupName, categoryName: String?
    let distance, id, phone, placeName: String?
    let placeURL: String?
    let roadAddressName, x, y: String?

    enum CodingKeys: String, CodingKey {
        case addressName = "address_name"
        case categoryGroupCode = "category_group_code"
        case categoryGroupName = "category_group_name"
        case categoryName = "category_name"
        case distance, id, phone
        case placeName = "place_name"
        case placeURL = "place_url"
        case roadAddressName = "road_address_name"
        case x, y
    }
}

// MARK: - Meta
struct RouteMeta: Codable {
    let isEnd: Bool?
    let pageableCount: Int?
    let sameName: RouteSameName?
    let totalCount: Int?

    enum CodingKeys: String, CodingKey {
        case isEnd = "is_end"
        case pageableCount = "pageable_count"
        case sameName = "same_name"
        case totalCount = "total_count"
    }
}

// MARK: - SameName
struct RouteSameName: Codable {
    let keyword: String?
    let region: [String]?
    let selectedRegion: String?

    enum CodingKeys: String, CodingKey {
        case keyword, region
        case selectedRegion = "selected_region"
    }
}

