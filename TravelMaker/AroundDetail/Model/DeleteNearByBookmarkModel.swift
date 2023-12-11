//
//  DeleteNearByBookmarkModel.swift
//  TravelMaker
//
//  Created by 이찬호 on 12/11/23.
//

import Foundation

struct DeleteNearByBookmarkModel: Codable {
    let data: DeleteNearByBookmark?
    let message: String?
}

// MARK: - DeleteNearByBookmark
struct DeleteNearByBookmark: Codable {
    let raw: [NearbyBookmarkRaw]?
    let affected: Int?
}
