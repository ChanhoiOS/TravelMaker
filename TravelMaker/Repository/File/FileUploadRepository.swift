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
            header = ["Authorization": accessToken]
        }
        
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(Data(model.content.utf8),
                                     withName: "content")
            multipartFormData.append(Data(model.placeName.utf8),
                                     withName: "placeName")
            multipartFormData.append(Data(model.dateTime.utf8),
                                     withName: "dateTime")
            multipartFormData.append(Data(String(model.latitude).utf8),
                                     withName: "latitude")
            multipartFormData.append(Data(String(model.longitude).utf8),
                                     withName: "longitude")
            multipartFormData.append(Data(String(model.address).utf8),
                                     withName: "address")
            multipartFormData.append(Data(String(model.categoryName).utf8),
                                     withName: "categoryName")
            multipartFormData.append(Data(String(model.starRating).utf8),
                                     withName: "starRating")
            
            if let imageArray = model.imageFiles {
                for (idx, images) in imageArray.enumerated() {
                    multipartFormData.append(images,
                                             withName: "nearMe",
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
