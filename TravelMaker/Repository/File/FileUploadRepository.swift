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
    
    func uploadProfileData(url: String,
                             with model: RequestProfileImageModel,
                             successHandler: @escaping ((MyPageModel) -> Void),
                             failureHandler: @escaping ((AFError) -> Void)) {
        
        if let accessToken = SessionManager.shared.accessToken {
            header = ["Authorization": "Bearer " + accessToken]
        }
        
        AF.upload(multipartFormData: { multipartFormData in
            if let imageFiles = model.imageFiles {
                multipartFormData.append(imageFiles,
                                        withName: "imageFiles",
                                        fileName: "image_profile",
                                        mimeType: "image/jpg")
            }
        }, to: url,
                  headers: header)
        .responseDecodable(of: MyPageModel.self) { response in
            switch response.result {
            case .success(let data):
                successHandler(data)
            case .failure(let error):
                failureHandler(error)
            }}
    }
    
    func uploadRouteData(url: String,
                             with model: RequestRegisterRouteModel,
                             successHandler: @escaping ((ResponseRegisterRouteModel) -> Void),
                             failureHandler: @escaping ((AFError) -> Void)) {
        
        if let accessToken = SessionManager.shared.accessToken {
            header = ["Authorization": "Bearer " + accessToken]
        }
        
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(Data(model.title.utf8),
                                     withName: "title")
            multipartFormData.append(Data(model.startDate.utf8),
                                     withName: "startDate")
            multipartFormData.append(Data(model.endDate.utf8),
                                     withName: "endDate")
//            multipartFormData.append(Data(model.routeAddressList.utf8),
//                                     withName: "routeAddressList")
            
            if let routeAddressList = model.routeAddressList {
                do {
                    let jsonData = try JSONEncoder().encode(routeAddressList)
                    let jsonString = String(data: jsonData, encoding: .utf8)
                    if let jsonString = jsonString {
                        multipartFormData.append(Data(jsonString.utf8),
                                                 withName: "routeAddressList",
                                                 mimeType: "application/json")
                    }
                    } catch {
                        print("Error encoding routeAddressList to JSON: \(error)")
                    }
                }
            
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
        .responseDecodable(of: ResponseRegisterRouteModel.self) { response in
            switch response.result {
            case .success(let data):
                successHandler(data)
            case .failure(let error):
                failureHandler(error)
            }}
    }
}
