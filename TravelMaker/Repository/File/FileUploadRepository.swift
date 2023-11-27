//
//  FileUploadManager.swift
//  TravelMaker
//
//  Created by 이찬호 on 10/23/23.
//

import Foundation
import Alamofire

class FileUploadRepository {
    
    static var shared = FileUploadRepository()
    
    var header: HTTPHeaders = [
        "Content-Type":"application/json",
    ]
    
    func uploadArroundMeData(url: String,
                             with model: RequestRegisterNearMeModel,
                             successHandler: @escaping ((ResponseRegisterNearMeModel) -> Void),
                             failureHandler: @escaping ((AFError) -> Void)) {
        
        if let accessToken = SessionManager.shared.accessToken {
            header = ["Authorization": "Bearer " + accessToken]
        }
        
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(Data(model.content.utf8),
                                     withName: "content")
            multipartFormData.append(Data(model.place_name.utf8),
                                     withName: "place_name")
            multipartFormData.append(Data(model.dateTime.utf8),
                                     withName: "dateTime")
            multipartFormData.append(Data(String(model.latitude).utf8),
                                     withName: "latitude")
            multipartFormData.append(Data(String(model.longitude).utf8),
                                     withName: "longitude")
            multipartFormData.append(Data(String(model.address).utf8),
                                     withName: "address")
            multipartFormData.append(Data(String(model.category_name).utf8),
                                     withName: "category_name")
            multipartFormData.append(Data(String(model.star_rating).utf8),
                                     withName: "star_rating")
            
            if let imageArray = model.imageFiles {
                for (idx, images) in imageArray.enumerated() {
                    multipartFormData.append(images,
                                             withName: "imageFiles",
                                             fileName: "image_\(idx)",
                                             mimeType: "image/jpg")
                }
            }
            
        }, to: url,
                  headers: header)
        .responseDecodable(of: ResponseRegisterNearMeModel.self) { response in
            switch response.result {
            case .success(let data):
                successHandler(data)
            case .failure(let error):
                failureHandler(error)
            }}
    }
}
