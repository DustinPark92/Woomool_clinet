//
//  Request.swift
//  Woomool
//
//  Created by Dustin on 2020/10/02.
//  Copyright © 2020 Woomool. All rights reserved.
//


import Foundation
import Alamofire
import SwiftyJSON
import UIKit

extension Data {
    var prettyPrintedJSONString: NSString? { /// NSString gives us a nice sanitized debugDescription
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }

        return prettyPrintedString
    }
}

struct ErrorHandling : Codable {
    let code : Int
    let message : String
    let method : String
    let url : String
}


class APIRequest {
    
    let defaults = UserDefaults.standard


    
    static let shared = APIRequest()
    
    
     //MARK: - TOKEN
    func postUserToken(parameters : [String:Any], success : @escaping (JSON) -> () ) {


        let url = URLSource.token
    
        let credentialData = "\(SecretKey.id):\(SecretKey.authorization)".data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString(options: [])
        
        print(base64Credentials)

        let headers : HTTPHeaders = ["Content-Type": "application/x-www-form-urlencoded",
                                     "Authorization" : "Basic \(base64Credentials)"]

        AF.request(url, method: .post, parameters: parameters,encoding:URLEncoding.default ,headers: headers)
            .responseJSON
             { response in
      
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    print("JSON: \(json)")
                    success(json)
                    
                    self.defaults.setValue(json["access_token"].stringValue, forKey: "accessToken")
                    self.defaults.setValue(json["refresh_token"].stringValue, forKey: "refreshToken")
                    
                case .failure(let error):
                    print(error.localizedDescription)
                }

         }
    }
        
    func postUserRefreshToken(success : @escaping (JSON) -> () ) {


            let url = URLSource.token
            guard  let refreshToken = defaults.object(forKey: "refreshToken") else { return }
            print("리프레시 \(refreshToken)")
            let params = ["grant_type": "refresh_token",
                          "scope" : "read+write",
                          "refresh_token" : refreshToken]
        
            let headers : HTTPHeaders =
                ["Content-Type": "application/x-www-form-urlencoded",
                "Authorization" : "\(SecretKey.authorization)"]

        
            AF.request(url, method: .post, parameters: params,encoding:URLEncoding.default ,headers: headers)
                .responseJSON
                 { response in
          
                    switch response.result {
                    case .success(let value):
                        let json = JSON(value)
                        print("JSON: \(json)")
                            
                        
                        if response.response?.statusCode == 200 || response.response?.statusCode == 201 {
                           
                        self.defaults.setValue(json["access_token"].stringValue, forKey: "accessToken")
                        self.defaults.setValue(json["refresh_token"].stringValue, forKey: "refreshToken")
                            
                            
                            success(json)
                    }
  
                        

                    case .failure(let error):
                        print(error.localizedDescription)
                    }

             }
    
    }
    
    //MARK: - TERMS
    
    func postTerms(termsIdArray : Array<String>,success : @escaping (JSON) -> () ) {

        
        let url = URLSource.terms
        guard let userId = defaults.object(forKey: "userId") else {
            return
        }
        let params = [
                       "userId": userId,
                       "terms":
                           [
                               ["status": "Y",
                                "termsId": termsIdArray[0]]
                               ,["status": "Y",
                                 "termsId": termsIdArray[1]]
                               ,["status": "Y",
                                 "termsId": termsIdArray[2]]
                               ,["status": "Y",
                                 "termsId": termsIdArray[3]]
                           ]
                       
                   ]
   
        
        
        
        AF.request(url,method: .post, parameters: params,encoding: JSONEncoding.default,interceptor: tokenInterceptor())
            .responseJSON
             { response in
      
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    print("JSON: \(json)")
                    success(json)
                case .failure(let error):
                    print(error.localizedDescription)
                }

         }
    }

    
    //MARK: - USER
    func postUserSignUp(parameters : [String:Any], success : @escaping (JSON) -> () ) {

        let url = URLSource.user

        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().responseJSON { response in


                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    print("JSON: \(json)")
                    success(json)
                    self.defaults.setValue(json["userId"].stringValue, forKey: "userId")
                case .failure(let error):
                    print(error.localizedDescription)
                }

            }
         }
    
    func postUserLogin(parameters : [String:Any], success : @escaping (JSON) -> () ) {

        let url = URLSource.login
 
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, interceptor: tokenInterceptor()).validate().responseJSON { response in


                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    print("JSON: \(json)")
                    success(json)
                    self.defaults.setValue(json["userId"].stringValue, forKey: "userId")
                case .failure(let error):
                    print(error.localizedDescription)
                }

            }
         }
    
    
    
    func postSNSUserLogin(type: String,snsToken : String, success : @escaping (JSON) -> () , invalid : @escaping(JSON) -> ()) {

        let url = URLSource.login + "/" + type

        
        let param = [
            "token" : snsToken,
        ] as [String : Any]
        

        AF.request(url, method: .post, parameters: param, encoding: JSONEncoding.default).validate().responseJSON { response in


                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    print("JSON: \(json)")
                    
                    if response.response?.statusCode == 200 {
                        invalid(json)
                    } else {
                    success(json)
                    self.defaults.setValue(json["userId"].stringValue, forKey: "userId")
                    self.defaults.setValue(json["access_token"].stringValue, forKey: "accessToken")
                    self.defaults.setValue(json["refresh_token"].stringValue, forKey: "refreshToken")
                    }
                    
                case .failure(let error):
                    print(error.localizedDescription)
                }

            }
         }
    
    
    func postAppleUserLogin(id : String,name : String, email : String, success : @escaping (JSON) -> () , invalid : @escaping(JSON) -> ()) {

        let url = URLSource.login + "/" + "apple"

        
        let param = [
            "id" : id,
            "name" : name,
            "email" : email
        ] as [String : Any]
        

        AF.request(url, method: .post, parameters: param, encoding: JSONEncoding.default).validate().responseJSON { response in


                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    print("JSON: \(json)")
                    
                    if response.response?.statusCode == 200 {
                        invalid(json)
                    } else {
                    success(json)
                    self.defaults.setValue(json["userId"].stringValue, forKey: "userId")
                    self.defaults.setValue(json["access_token"].stringValue, forKey: "accessToken")
                    self.defaults.setValue(json["refresh_token"].stringValue, forKey: "refreshToken")
                    }
                    
                case .failure(let error):
                    print(error.localizedDescription)
                }

            }
         }
    
    func getUserInfo(success : @escaping (JSON) -> ()) {
        
    

        guard let userId = defaults.object(forKey: "userId") else { return }
       
        let url = URLSource.user + "/" + "\(userId)"
        
        
        print(url)
        AF.request(url, method: .get,encoding: JSONEncoding.default,interceptor: tokenInterceptor()).validate().responseJSON { response in

                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    print("JSON: \(json)")
                    success(json)

                case .failure(let error):
                    print(error.localizedDescription)
    
                }

            }
         }
    
    
    func getUserEnviroment(success : @escaping (JSON) -> ()) {
        
    

        guard let userId = defaults.object(forKey: "userId") else { return }
       
        let url = URLSource.envir + "\(userId)"
        
        
        print(url)
        AF.request(url, method: .get,interceptor: tokenInterceptor()).validate().responseJSON { response in

                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    print("JSON: \(json)")
                    success(json)

                case .failure(let error):
                    print(error.localizedDescription)
    
                }

            }
         }
    
    func delUser(success : @escaping (JSON) -> ()) {

        guard let userId = defaults.object(forKey: "userId") else { return }

        let url = URLSource.user + "/" + "\(userId)"
        AF.request(url, method: .delete,encoding: JSONEncoding.default,interceptor: tokenInterceptor()).validate().responseJSON { response in

                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    print("JSON: \(json)")
                    success(json)

                case .failure(let error):
                       
        
                    print(error.localizedDescription)
                }

            }
         }
    
    func putChangeUserInfo(newPassword : String,nickname: String,oldPassword : String,success : @escaping (JSON) -> ()) {
        
        guard let userId = defaults.object(forKey: "userId") else { return }

        let params = [
              "newPassword": newPassword,
              "nickname": nickname,
              "oldPassword": oldPassword,
              "userId": userId
        ]
        
        

        let url = URLSource.user
        AF.request(url, method: .put,parameters: params,encoding: JSONEncoding.default, interceptor: tokenInterceptor()).validate().responseJSON { response in

                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    print("JSON: \(json)")
                    success(json)

                case .failure(let error):
                    print(error.localizedDescription)
                }

            }
         }

    
    //MARK: - STORE
    
    func getStoreList(lat : Double,lon : Double,success : @escaping (JSON) -> ()) {

        let url = URLSource.store


        let params = [
            "latitude" : String(lat),
            "longitude" : String(lon)
        ]
        
        AF.request(url, method: .get,parameters: params, interceptor: tokenInterceptor()).validate().responseJSON { response in

                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    print("JSON: \(json)")
                    success(json)

                case .failure(let error):
                    print(error.localizedDescription)
                }

            }
         }
    func getStoreDetail(storeId : String,lat : Double,lon : Double,success : @escaping (JSON) -> ()) {

        let url = URLSource.storeDetail

        let params = [
            "storeId" : storeId,
            "latitude" : String(lat),
            "longitude" : String(lon)
        ]
        
        AF.request(url, method: .get,parameters: params, interceptor: tokenInterceptor()).validate().responseJSON { response in

                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    print("JSON: \(json)")
                    success(json)

                case .failure(let error):

                    print(error.localizedDescription)
                }

            }
         }
    
    func getBestStoreList(success : @escaping (JSON) -> ()) {

        let url = URLSource.storeBest
        AF.request(url, method: .get, interceptor: tokenInterceptor()).validate().responseJSON { response in

                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    print("JSON: \(json)")
                    success(json)

                case .failure(let error):
                    print(error.localizedDescription)
                }

            }
         }
    
    
    func getFindStoreList(inputStoreName Name : String,success : @escaping (JSON) -> ()) {
        let escapingCharacterSet: CharacterSet = {
            var cs = CharacterSet.alphanumerics
            cs.insert(charactersIn: "-_.~")
            return cs }()
        
       let encodingName =  Name.addingPercentEncoding(withAllowedCharacters: escapingCharacterSet)!
        
     
        let url = URLSource.storeFind + encodingName

        AF.request(url, method: .get, interceptor: tokenInterceptor()).validate().responseJSON { response in

                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    print("JSON: \(json)")
                    success(json)

                case .failure(let error):
                    print(error.localizedDescription)
                }

            }
         }
    
    func postStoreApply(parameters : [String:Any], success : @escaping (JSON) -> () ) {

        let url = URLSource.storeApply

        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default,interceptor: tokenInterceptor()).validate().responseJSON { response in


                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    print("JSON: \(json)")
                    success(json)
                    
                case .failure(let error):
                    print(error.localizedDescription)
                }

            }
         }
    
    func getStoreLookUp(storeId : String,success : @escaping (JSON) -> ()) {

     
        let url = URLSource.store + "/" + storeId
        AF.request(url, method: .get,interceptor: tokenInterceptor()).validate().responseJSON { response in

                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    print("JSON: \(json)")
                    success(json)

                case .failure(let error):
                    print(error.localizedDescription)

                }

            }
         }
    
    func postStoreUse(storeId:String, success : @escaping (JSON) -> ()) {

        let url = URLSource.store
        guard let userId = defaults.object(forKey: "userId") as? String else { return }
    
    
        let params = [
              "storeId": storeId,
              "userId": userId
        ]



        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, interceptor: tokenInterceptor()).validate().responseJSON { response in


                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    print("JSON: \(json)")
                    success(json)
                    
                case .failure(let error):
        
                    print(error.localizedDescription)
                }

            }
         }
    func putStoreScope(storeNo:Int,scope : Float, success : @escaping (JSON) -> ()) {

        let url = URLSource.store

       
        let params = [
              "scope": scope,
              "storeNo": storeNo
        ] as [String : Any]


        AF.request(url, method: .put, parameters: params, encoding: JSONEncoding.default,interceptor: tokenInterceptor()).validate().responseJSON { response in


                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    print("JSON: \(json)")
                    success(json)
                    
                case .failure(let error):
         
                    print(error.localizedDescription)
                }

            }
         }


    //MARK: - NOTICE
    
    
    func getNoticeList(success : @escaping (JSON) -> ()) {

        let url = URLSource.notice
        AF.request(url, method: .get,encoding: JSONEncoding.default, interceptor: tokenInterceptor()).validate().responseJSON { response in

                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    print("JSON: \(json)")
                    success(json)

                case .failure(let error):
                    print(error.localizedDescription)
                }

            }
         }
    
    func getNoticeListDetail(inputNoticeId id : String,success : @escaping (JSON) -> ()) {

        let url = URLSource.notice + "/" + id
        AF.request(url, method: .get,encoding: JSONEncoding.default, interceptor: tokenInterceptor()).validate().responseJSON { response in

                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    print("JSON: \(json)")
                    success(json)

                case .failure(let error):
                    print(error.localizedDescription)
                }

            }
         }
    
    
    //MARK: - EVENT
    
    
    func getEventList(success : @escaping (JSON) -> ()) {

        let url = URLSource.event

        AF.request(url, method: .get,encoding: JSONEncoding.default, interceptor: tokenInterceptor()).validate().responseJSON { response in

                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    print("JSON: \(json)")
                    success(json)

                case .failure(let error):

                    print(error.localizedDescription)
                }

            }
         }
    
    func getEventListDetail(inputEventId id : String,success : @escaping (JSON) -> ()) {

        let url = URLSource.event + "/" + id

        AF.request(url, method: .get,encoding: JSONEncoding.default, interceptor: tokenInterceptor()).validate().responseJSON { response in

                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    print("JSON: \(json)")
                    success(json)

                case .failure(let error):
                    print(error.localizedDescription)
                }

            }
         }
    
    //MARK: - Goods
    
    
    func getGoodsList(success : @escaping (JSON) -> ()) {

        
        
        guard let userId = defaults.object(forKey: "userId") as? String else { return }

        let url = URLSource.goods + userId
        AF.request(url, method: .get,encoding: JSONEncoding.default, interceptor: tokenInterceptor()).validate().responseJSON { response in

                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    print("JSON: \(json)")
                    success(json)

                case .failure(let error):
                    print(error.localizedDescription)
                }

            }
         }
    
    
    func getPurchaseHistory(success : @escaping (JSON) -> ()) {

        guard let userId = defaults.object(forKey: "userId") as? String else { return }
 
        let url = URLSource.goodPurchase + userId
        AF.request(url, method: .get,encoding: JSONEncoding.default, interceptor: tokenInterceptor()).validate().responseJSON { response in

                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    print("JSON: \(json)")
                    success(json)

                case .failure(let error):
                    print(error.localizedDescription)
                }

            }
         }
    
    func PostGoodsPurchase(couponId : String, goodsId : String,payMethod : String , amount : Int , success : @escaping (JSON) -> ()) {


        
        guard let userId = defaults.object(forKey: "userId") as? String else { return }
        
        let parameters = [
            "couponId": couponId,
            "goodsId": goodsId,
            "payMethod": payMethod,
            "amount": amount,
            "userId": userId
        ] as [String : Any]

        let url = URLSource.goodPurchase
        AF.request(url, method: .post,parameters: parameters,encoding: JSONEncoding.default, interceptor: tokenInterceptor()).validate().responseJSON { response in

                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    print("JSON: \(json)")
                    success(json)

                case .failure(let error):
                    print(error.errorDescription)
                    
        
                    if let responseData = response.data {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                        
                    
//
                    
                    print(error)
                }

            }
         }
    }
    
    
    //MARK: - FAQ
    
    
    func getFAQCategory(success : @escaping (JSON) -> ()) {

        let url = URLSource.faq
        guard let token = defaults.object(forKey: "accessToken") else { return }

        AF.request(url, method: .get,encoding: JSONEncoding.default, interceptor: tokenInterceptor()).validate().responseJSON { response in

                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    print("JSON: \(json)")
                    success(json)

                case .failure(let error):
         
                    print(error.localizedDescription)
                }

            }
         }
    
    
    func getFAQDetail(groupId : String,success : @escaping (JSON) -> (),refreshSuccess : @escaping() -> ()) {

        let url = URLSource.faq  + "/" + groupId

        AF.request(url, method: .get,encoding: JSONEncoding.default, interceptor: tokenInterceptor()).validate().responseJSON { response in

                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    print("JSON: \(json)")
                    success(json)

                case .failure(let error):
                    print(error.localizedDescription)
                }

            }
         }
    
    func getEventListDetail(inputFAQId id : String,success : @escaping (JSON) -> ()) {

        let url = URLSource.faq + "/" + id
        guard let token = defaults.object(forKey: "accessToken") else { return }
        let header : HTTPHeaders = ["Authorization" : "Bearer \(token)"]
        AF.request(url, method: .get,encoding: JSONEncoding.default, headers: header).validate().responseJSON { response in

                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    print("JSON: \(json)")
                    success(json)

                case .failure(let error):
                    print(error.localizedDescription)
                }

            }
         }
    
    
    //MARK: - 회원 등급별 목록
    func getUserRank(success : @escaping (JSON) -> ()) {

        
        guard let token = UserDefaults.standard.object(forKey: "accessToken") else { return }
        
        guard let userId = defaults.object(forKey: "userId") as? String else { return }
        let header : HTTPHeaders = ["Authorization" : "Bearer \(token)"]
        let url = URLSource.userRank + userId
        AF.request(url, method: .get,encoding: JSONEncoding.default, headers: header).validate().responseJSON { response in

                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    print("JSON: \(json)")
                    success(json)

                case .failure(let error):
                    print(error.localizedDescription)
                }

            }
         }
    
    
    //MARK: - 배너
    func getBanner(postion : String,success : @escaping (JSON) -> (),refreshSuccess: @escaping() -> ()) {

        
        guard let token = UserDefaults.standard.object(forKey: "accessToken") else { return }
        

        let header : HTTPHeaders = ["Authorization" : "Bearer \(token)"]
        let url = URLSource.banner + postion
        AF.request(url, method: .get,encoding: JSONEncoding.default, headers: header).validate().responseJSON { response in

                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    print("JSON: \(json)")
                    success(json)

                case .failure(let error):
                    print(error.localizedDescription)
                    if response.response?.statusCode == 401 {
                        
                        APIRequest.shared.postUserRefreshToken { json in
                            refreshSuccess()
    
                            self.defaults.setValue(json["access_token"].stringValue, forKey: "accessToken")
                            self.defaults.setValue(json["refresh_token"].stringValue, forKey: "refreshToken")
                        }
                       
                        
                    }
                }

            }
         }
    
    //MARK: - 유저 알림
    
    func getUserNoti(success : @escaping (JSON) -> (),refreshSuccess: @escaping() -> ()) {

        
        guard let token = UserDefaults.standard.object(forKey: "accessToken") else { return }
        guard let userId = defaults.object(forKey: "userId") else { return }

        let header : HTTPHeaders = ["Authorization" : "Bearer \(token)"]
        let url = URLSource.userNoti + "\(userId)"
        AF.request(url, method: .get,encoding: JSONEncoding.default, headers: header).validate().responseJSON { response in

                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    print("JSON: \(json)")
                    success(json)

                case .failure(let error):
                    print(error.localizedDescription)
                    if response.response?.statusCode == 401 {
                        
                        APIRequest.shared.postUserRefreshToken { json in
                            refreshSuccess()
    
                            self.defaults.setValue(json["access_token"].stringValue, forKey: "accessToken")
                            self.defaults.setValue(json["refresh_token"].stringValue, forKey: "refreshToken")
                        }
                       
                        
                    }
                }

            }
         }
    
    
    func putUserNotiReading(messageNo : Int,success : @escaping (JSON) -> (),refreshSuccess: @escaping() -> ()) {

        
        guard let token = UserDefaults.standard.object(forKey: "accessToken") else { return }

        let header : HTTPHeaders = ["Authorization" : "Bearer \(token)"]
        let url = URLSource.userNoti + "\(messageNo)"
        AF.request(url, method: .put,encoding: JSONEncoding.default, headers: header).validate().responseJSON { response in

                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    print("JSON: \(json)")
                    success(json)

                case .failure(let error):
                    print(error.localizedDescription)
                    if response.response?.statusCode == 401 {
                        
                        APIRequest.shared.postUserRefreshToken { json in
                            refreshSuccess()
    
                            self.defaults.setValue(json["access_token"].stringValue, forKey: "accessToken")
                            self.defaults.setValue(json["refresh_token"].stringValue, forKey: "refreshToken")
                        }
                       
                        
                    }
                }

            }
         }
    
    
    
    //MARK : - 초대 코드 발급
    
    func getInviteCode(success : @escaping (JSON) -> (),refreshSuccess: @escaping() -> ()) {

        
        guard let token = UserDefaults.standard.object(forKey: "accessToken") else { return }
        guard let userId = defaults.object(forKey: "userId") else { return }

        let header : HTTPHeaders = ["Authorization" : "Bearer \(token)"]
        let url = URLSource.invite + "\(userId)"
        AF.request(url, method: .get,encoding: JSONEncoding.default, headers: header).validate().responseJSON { response in

                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    print("JSON: \(json)")
                    success(json)

                case .failure(let error):
                    print(error.localizedDescription)
                    if response.response?.statusCode == 401 {
                        
                        APIRequest.shared.postUserRefreshToken { json in
                            refreshSuccess()
    
                            self.defaults.setValue(json["access_token"].stringValue, forKey: "accessToken")
                            self.defaults.setValue(json["refresh_token"].stringValue, forKey: "refreshToken")
                        }
                       
                        
                    }
                }

            }
         }
    
    //MARK: - 쿠폰 / coupon
    func getUserCoupon(success : @escaping (JSON) -> (),refreshSuccess: @escaping() -> ()) {

        
        guard let token = UserDefaults.standard.object(forKey: "accessToken") else { return }
        guard let userId = defaults.object(forKey: "userId") else { return }

        let header : HTTPHeaders = ["Authorization" : "Bearer \(token)"]
        let url = URLSource.coupon + "\(userId)"
        AF.request(url, method: .get,encoding: JSONEncoding.default, headers: header).validate().responseJSON { response in

                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    print("JSON: \(json)")
                    success(json)

                case .failure(let error):
                    print(error.localizedDescription)
                    if response.response?.statusCode == 401 {
                        
                        APIRequest.shared.postUserRefreshToken { json in
                            refreshSuccess()
    
                            self.defaults.setValue(json["access_token"].stringValue, forKey: "accessToken")
                            self.defaults.setValue(json["refresh_token"].stringValue, forKey: "refreshToken")
                        }
                       
                        
                    }
                }

            }
         }
    
    
    //MARK: - 불만 사항 / Complain
    
    func postStoreComplain(storeId:String,contents: String, success : @escaping (JSON) -> (),refreshSuccess : @escaping() -> () ) {

        let url = URLSource.storeComplain
        guard let token = defaults.object(forKey: "accessToken") else { return }
        guard let userId = defaults.object(forKey: "userId") as? String else { return }
        let params = [
              "contents": contents,
              "storeId": storeId,
              "userId": userId
        ]

        let header : HTTPHeaders = ["Content-Type" : "application/json",
                                    "authorization" : "Bearer \(token)" ]

        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: header).validate().responseJSON { response in


                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    print("JSON: \(json)")
                    success(json)
                    
                case .failure(let error):
                    if response.response?.statusCode == 401 {
                        
                        APIRequest.shared.postUserRefreshToken { json in
                            refreshSuccess()
    
                            self.defaults.setValue(json["access_token"].stringValue, forKey: "accessToken")
                            self.defaults.setValue(json["refresh_token"].stringValue, forKey: "refreshToken")
                        }
                       
                        
                    }
                    print(error.localizedDescription)
                }

            }
         }
    
    
    //MARK: - 내역 / History
    
    func getHistory(type : String,searchMonth : String,success : @escaping (JSON) -> (),refreshSuccess: @escaping() -> ()) {

        
        guard let token = UserDefaults.standard.object(forKey: "accessToken") else { return }
        guard let userId = defaults.object(forKey: "userId") else { return }

        
        
        let params = [
              "searchMonth" : searchMonth,
              "userId": userId
        ]
        let header : HTTPHeaders = ["Authorization" : "Bearer \(token)"]
        let url = URLSource.history + type
        AF.request(url, method: .get,parameters: params, headers: header).validate().responseJSON { response in

                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    print("JSON: \(json)")
                    success(json)

                case .failure(let error):
                    print(error.localizedDescription)
                    if response.response?.statusCode == 401 {
                        
                        APIRequest.shared.postUserRefreshToken { json in
                            refreshSuccess()
    
                            self.defaults.setValue(json["access_token"].stringValue, forKey: "accessToken")
                            self.defaults.setValue(json["refresh_token"].stringValue, forKey: "refreshToken")
                        }
                       
                        
                    }
                }

            }
         }
    
    
    //MARK: - 인증 / CERT
    
    func postCertUser(success : @escaping (JSON) -> ()) {

        let url = URLSource.cert

        let header : HTTPHeaders = ["Content-Type" : "application/json"]

        AF.request(url, method: .post, encoding: JSONEncoding.default, headers: header).validate().responseJSON { response in


                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    print("JSON: \(json)")
                    success(json)
                    
                case .failure(let error):
                    print(error.localizedDescription)
                }

            }
         }
    
    
}
