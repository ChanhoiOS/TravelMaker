//
//  Apis.swift
//  TravelMaker
//
//  Created by 이찬호 on 2023/09/11.
//

import Foundation

struct Apis {
    static let baseUrl2 = "http://43.200.32.96:8140"
    
    static let postAround = "\(Apis.baseUrl2)/api/post"
    
    static let getAround = "\(Apis.baseUrl2)/api/post/all"
    
    static let recommendAll = "\(Apis.baseUrl2)/api/place/all"
    
    static let imageUrl = "\(Apis.baseUrl2)/images/"
    
    
    
    
    
    static let baseUrl = "http://mytravelmaker.shop:3000"
    
 
    
    
    
    static let join = "\(Apis.baseUrl)/api/user/join"
    
    static let leave = "\(Apis.baseUrl)/api/user/delete"
    
    static let leave_reason = "\(Apis.baseUrl)/api/delete_account"
    
    static let nickname_check = "\(Apis.baseUrl)/api/user/nickname/check"
    
    static let login = "\(Apis.baseUrl)/api/auth/login"
    
    static let update = "\(Apis.baseUrl)/api/user/update"
    
    static let update_image = "\(Apis.baseUrl)/api/user/update/image"
    
    
    
    static let recommend_all = "\(Apis.baseUrl)/api/recommend/all"
    
    static let recommend_one = "\(Apis.baseUrl)/api/recommend"
    
    static let bookmark_add = "\(Apis.baseUrl)/api/recommend_bookmark/add"
    
    static let bookmark_recommend = "\(Apis.baseUrl)/api/recommend_bookmark"
    
    static let bookmark_delete = "\(Apis.baseUrl)/api/recommend_bookmark"
    
    
    
    static let nearby_add = "\(Apis.baseUrl)/api/nearby/post"
    
    static let nearby_all = "\(Apis.baseUrl)/api/nearby/all"
    
    static let nearby_one = "\(Apis.baseUrl)/api/nearby"
    
    static let nearby_add_bookmark = "\(Apis.baseUrl)/api/nearby_bookmark/add"
    
    static let nearby_bookmark_all = "\(Apis.baseUrl)/api/nearby_bookmark"
    
    static let nearby_delete_bookmark = "\(Apis.baseUrl)/api/nearby_bookmark"
    
    
    
    static let route_add = "\(Apis.baseUrl)/api/route/add"
    
    static let route_all = "\(Apis.baseUrl)/api/route"
    
    static let route_one = "\(Apis.baseUrl)/api/route"
    
    static let route_delete = "\(Apis.baseUrl)/api/route/delete"
    
    static let route_size = "\(Apis.baseUrl)/api/route/bookmark/size"
    
    
    
    
    static let dowonload_image = "\(Apis.baseUrl)/api/file/download/image/MTY5NzQyOTI0NjgyNw==.jpeg"
    
    
}
