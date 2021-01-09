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
    /*
     private String error;
     private String code;
     private String message;
     private String path;
     private String timestamp;
     */
    let status : Int
    let error : String
    let code = "999"
    let message : String
    let path : String
    let timestamp : String
    
}


struct tokenErrorHandling : Codable {

    let status : Int
    let error : String
    let code = "999"
    let message : String
    let path : String
    let timestamp : String
    
}

class APIRequest {
    
    let defaults = UserDefaults.standard


    
    static let shared = APIRequest()
    
    
     //MARK: - TOKEN
    func postUserToken(parameters : [String:Any], success : @escaping (JSON) -> () , fail : @escaping(String) -> ()) {


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
                    fail(error.localizedDescription)
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
                            success(json)
                    }
  
                        

                    case .failure(let error):
                        print(error.localizedDescription)
                    }

             }
    
    }
    
    //MARK: - TERMS
    
    func postTerms(statusArray : Array<String>,termsIdArray : Array<String>,success : @escaping (JSON) -> ()) {

        
        let url = URLSource.terms
        guard let userId = defaults.object(forKey: "userId") else {
            return
        }
        let params = [
                       "userId": userId,
                       "terms":
                           [
                               ["status": statusArray[0],
                                "termsId": termsIdArray[0]]
                               ,["status": statusArray[1],
                                 "termsId": termsIdArray[1]]
                               ,["status": statusArray[2],
                                 "termsId": termsIdArray[2]]
                               ,["status": statusArray[3],
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
    
    
    func getTerms(success : @escaping(JSON) -> ()) {

        let url = URLSource.requiredTerms
        
        
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

    
    //MARK: - USER / 회원 관련
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
    
    func postSNSUserSignUp(transData : String,addtionalDataContents : [String], success : @escaping (JSON) -> () , fail : @escaping(ErrorHandling) -> ()) {

        let url = URLSource.user + "/sns"
        
        let params = [
              "birth": addtionalDataContents[1],
              "inviteCd": addtionalDataContents[4],
              "email": addtionalDataContents[3],
              "name": addtionalDataContents[0],
              "sex": addtionalDataContents[2],
              "transData": transData
        ]

        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default).validate().responseJSON { response in


                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    print("JSON: \(json)")
                    success(json)
    
                case .failure(let error):
                    if let responseData = response.data {
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase

                        let error : ErrorHandling = try! decoder.decode(ErrorHandling.self, from: responseData)


                        fail(error)
                    }
                }

            }
         }
    
    func postUserLogin(parameters : [String:Any], success : @escaping (JSON) -> (),fail : @escaping(ErrorHandling) -> ()) {

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
                    if let responseData = response.data {
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase

                        let error : ErrorHandling = try! decoder.decode(ErrorHandling.self, from: responseData)


                        fail(error)
                    }
                }

            }
         }
    
    
    
    func postSNSUserLogin(type: String,snsToken : String, success : @escaping (JSON) -> () , newUser : @escaping(JSON) -> (), fail : @escaping(ErrorHandling) -> ()) {

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
                        //기존 회원 일 경우
                        success(json)
                        self.defaults.setValue(json["userId"].stringValue, forKey: "userId")
                        self.defaults.setValue(json["access_token"].stringValue, forKey: "accessToken")
                        self.defaults.setValue(json["refresh_token"].stringValue, forKey: "refreshToken")
                    } else if response.response?.statusCode == 201{
                        //신규 회원 일 경우
                        newUser(json)

                    }
                    
                case .failure(let error):
                    if let responseData = response.data {
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase

                        let error : ErrorHandling = try! decoder.decode(ErrorHandling.self, from: responseData)
        
                        
                        fail(error)
                    }
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
    
    func getUserInfo(success : @escaping (JSON) -> (),fail : @escaping(ErrorHandling) -> ()) {
        
    

        guard let userId = defaults.object(forKey: "userId") else { return }
       
        let url = URLSource.user + "/" + "\(userId)"
   
        AF.request(url, method: .get,encoding: JSONEncoding.default,interceptor: tokenInterceptor()).validate().responseJSON { response in

                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    print("JSON: \(json)")
                    success(json)

                case .failure(let error):
                    if let responseData = response.data {
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase

                        let error : ErrorHandling = try! decoder.decode(ErrorHandling.self, from: responseData)


                       fail(error)
                    }
    
                }

            }
         }
    
    
    func getUserPrivacy(success : @escaping (JSON) -> (),fail : @escaping(ErrorHandling) -> ()) {
        
    

        guard let userId = defaults.object(forKey: "userId") else { return }
       
        let url = URLSource.privacy + "\(userId)"
   
        AF.request(url, method: .get,encoding: JSONEncoding.default,interceptor: tokenInterceptor()).validate().responseJSON { response in

                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    print("JSON: \(json)")
                    success(json)

                case .failure(let error):
                    if let responseData = response.data {
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase

                        let error : ErrorHandling = try! decoder.decode(ErrorHandling.self, from: responseData)


                        fail(error)
                    }
    
                }

            }
         }
    
    
    func getUserEnviroment(success : @escaping (JSON) -> (),fail : @escaping(ErrorHandling) -> ()) {
        
    

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
                    if let responseData = response.data {
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase

                        let error : ErrorHandling = try! decoder.decode(ErrorHandling.self, from: responseData)


                        fail(error)
                    }
                }

            }
         }
    
    
    func getFindUserPassword(email : String,success : @escaping (JSON) -> (),fail : @escaping(ErrorHandling) -> ()) {
        

        let url = URLSource.findPW + email
   
        AF.request(url, method: .get,encoding: JSONEncoding.default).validate().responseJSON { response in

                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    print("JSON: \(json)")
                    success(json)

                case .failure(let error):
                    if let responseData = response.data {
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase

                        let error : ErrorHandling = try! decoder.decode(ErrorHandling.self, from: responseData)


                        fail(error)
                    }
    
                }

            }
         }
    
    
    
    func delUser(reason : String,success : @escaping (JSON) -> (),fail : @escaping(ErrorHandling) -> ()) {

        guard let userId = defaults.object(forKey: "userId") else { return }
        
        let params = ["reason" : reason]
        
        print(" 탈퇴 이유는?? \(reason)")

        let url = URLSource.user + "/" + "\(userId)"
        AF.request(url, method: .delete,parameters: params,encoding: JSONEncoding.default,interceptor: tokenInterceptor()).validate().responseJSON { response in

                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    print("JSON: \(json)")
                    success(json)

                case .failure(let error):
                    if let responseData = response.data {
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase

                        let error : ErrorHandling = try! decoder.decode(ErrorHandling.self, from: responseData)


                        fail(error)
                    }
        
                    print(error.localizedDescription)
                }

            }
         }
    
    func putChangeUserInfo(newPassword : String,nickname: String,oldPassword : String,success : @escaping (JSON) -> (),fail : @escaping(ErrorHandling) -> ()) {
        
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
                    if let responseData = response.data {
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase

                        let error : ErrorHandling = try! decoder.decode(ErrorHandling.self, from: responseData)


                        fail(error)
                    }
                    print(error.localizedDescription)
                }

            }
         }

    
    //MARK: - STORE
    
    func getStoreList(lat : Double,lon : Double,success : @escaping (JSON) -> (),fail : @escaping(ErrorHandling) -> ()) {

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
                    if let responseData = response.data {
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase

                        let error : ErrorHandling = try! decoder.decode(ErrorHandling.self, from: responseData)


                        fail(error)
                    }
                    print(error.localizedDescription)
                }

            }
         }
    func getStoreDetail(storeId : String,lat : Double,lon : Double,success : @escaping (JSON) -> (),fail : @escaping(ErrorHandling) -> ()) {

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
                    if let responseData = response.data {
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase

                        let error : ErrorHandling = try! decoder.decode(ErrorHandling.self, from: responseData)


                        fail(error)
                    }

                    print(error.localizedDescription)
                }

            }
         }
    
    func getBestStoreList(success : @escaping (JSON) -> (),fail : @escaping(ErrorHandling) -> ()) {

        let url = URLSource.storeBest
        AF.request(url, method: .get, interceptor: tokenInterceptor()).validate().responseJSON { response in

                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    print("JSON: \(json)")
                    success(json)

                case .failure(let error):
                    if let responseData = response.data {
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase

                        let error : ErrorHandling = try! decoder.decode(ErrorHandling.self, from: responseData)


                        fail(error)
                    }
                    print(error.localizedDescription)
                }

            }
         }
    
    
    func getFindStoreList(inputStoreName Name : String,success : @escaping (JSON) -> (),fail : @escaping(ErrorHandling) -> ()) {
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
                    if let responseData = response.data {
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase

                        let error : ErrorHandling = try! decoder.decode(ErrorHandling.self, from: responseData)


                        fail(error)
                    }
                    print(error.localizedDescription)
                }

            }
         }
    
    func postStoreApply(parameters : [String:Any], success : @escaping (JSON) -> (),fail : @escaping(ErrorHandling) -> ()) {

        let url = URLSource.storeApply

        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default,interceptor: tokenInterceptor()).validate().responseJSON { response in


                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    print("JSON: \(json)")
                    success(json)
                    
                case .failure(let error):
                    if let responseData = response.data {
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase

                        let error : ErrorHandling = try! decoder.decode(ErrorHandling.self, from: responseData)


                        fail(error)
                    }
                    print(error.localizedDescription)
                }

            }
         }
    
    func getStoreLookUp(storeId : String,success : @escaping (JSON) -> (),fail : @escaping(ErrorHandling) -> ()) {

     
        let url = URLSource.store + "/" + storeId
        AF.request(url, method: .get,interceptor: tokenInterceptor()).validate().responseJSON { response in

                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    print("JSON: \(json)")
                    success(json)

                case .failure(let error):
                    if let responseData = response.data {
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase

                        let error : ErrorHandling = try! decoder.decode(ErrorHandling.self, from: responseData)


                        fail(error)
                    }
                    print(error.localizedDescription)

                }

            }
         }
    
    func postStoreUse(storeId:String, success : @escaping (JSON) -> (),fail : @escaping(ErrorHandling) -> ()) {

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
                    if let responseData = response.data {
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase

                        let error : ErrorHandling = try! decoder.decode(ErrorHandling.self, from: responseData)


                        fail(error)
                    }
                    print(error.localizedDescription)
                }

            }
         }
    func putStoreScope(storeNo:Int,scope : Float, success : @escaping (JSON) -> (),fail : @escaping(ErrorHandling) -> ()) {

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
                    if let responseData = response.data {
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase

                        let error : ErrorHandling = try! decoder.decode(ErrorHandling.self, from: responseData)


                        fail(error)
                    }
                    print(error.localizedDescription)
                }

            }
         }


    //MARK: - NOTICE
    
    
    func getNoticeList(success : @escaping (JSON) -> (),fail : @escaping(ErrorHandling) -> ()) {

        let url = URLSource.notice
        AF.request(url, method: .get,encoding: JSONEncoding.default, interceptor: tokenInterceptor()).validate().responseJSON { response in

                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    print("JSON: \(json)")
                    success(json)

                case .failure(let error):
                    if let responseData = response.data {
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase

                        let error : ErrorHandling = try! decoder.decode(ErrorHandling.self, from: responseData)


                        fail(error)
                    }
                    print(error.localizedDescription)
                }

            }
         }
    
    func getNoticeListDetail(inputNoticeId id : String,success : @escaping (JSON) -> (),fail : @escaping(ErrorHandling) -> ()) {

        let url = URLSource.notice + "/" + id
        AF.request(url, method: .get,encoding: JSONEncoding.default, interceptor: tokenInterceptor()).validate().responseJSON { response in

                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    print("JSON: \(json)")
                    success(json)

                case .failure(let error):
                    if let responseData = response.data {
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase

                        let error : ErrorHandling = try! decoder.decode(ErrorHandling.self, from: responseData)


                        fail(error)
                    }
                    print(error.localizedDescription)
                }

            }
         }
    
    
    //MARK: - EVENT
    
    
    func getEventList(success : @escaping (JSON) -> (),fail : @escaping(ErrorHandling) -> ()) {

        let url = URLSource.event

        AF.request(url, method: .get,encoding: JSONEncoding.default, interceptor: tokenInterceptor()).validate().responseJSON { response in

                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    print("JSON: \(json)")
                    success(json)

                case .failure(let error):
                    if let responseData = response.data {
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase

                        let error : ErrorHandling = try! decoder.decode(ErrorHandling.self, from: responseData)


                        fail(error)
                    }

                    print(error.localizedDescription)
                }

            }
         }
    
    func getEventListDetail(inputEventId id : String,success : @escaping (JSON) -> (),fail : @escaping(ErrorHandling) -> ()) {

        let url = URLSource.event + "/" + id

        AF.request(url, method: .get,encoding: JSONEncoding.default, interceptor: tokenInterceptor()).validate().responseJSON { response in

                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    print("JSON: \(json)")
                    success(json)

                case .failure(let error):
                    if let responseData = response.data {
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase

                        let error : ErrorHandling = try! decoder.decode(ErrorHandling.self, from: responseData)


                        fail(error)
                    }
                    print(error.localizedDescription)
                }

            }
         }
    
    //MARK: - Goods
    
    
    func getGoodsList(success : @escaping (JSON) -> (),fail : @escaping(ErrorHandling) -> ()) {

        
        
        guard let userId = defaults.object(forKey: "userId") as? String else { return }

        let url = URLSource.goods + userId
        AF.request(url, method: .get,encoding: JSONEncoding.default, interceptor: tokenInterceptor()).validate().responseJSON { response in

                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    print("JSON: \(json)")
                    success(json)

                case .failure(let error):
                    if let responseData = response.data {
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase

                        let error : ErrorHandling = try! decoder.decode(ErrorHandling.self, from: responseData)


                        fail(error)
                    }
                    print(error.localizedDescription)
                }

            }
         }
    
    
    func getPurchaseHistory(success : @escaping (JSON) -> (),fail : @escaping(ErrorHandling) -> ()) {

        guard let userId = defaults.object(forKey: "userId") as? String else { return }
 
        let url = URLSource.goodPurchase + userId
        AF.request(url, method: .get,encoding: JSONEncoding.default, interceptor: tokenInterceptor()).validate().responseJSON { response in

                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    print("JSON: \(json)")
                    success(json)

                case .failure(let error):
                    if let responseData = response.data {
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase

                        let error : ErrorHandling = try! decoder.decode(ErrorHandling.self, from: responseData)


                        fail(error)
                    }
                    print(error.localizedDescription)
                }

            }
         }
    
    func PostGoodsPurchase(couponId : String, goodsId : String,payMethod : String , amount : Int , success : @escaping (JSON) -> (),fail : @escaping(ErrorHandling) -> ()) {


        
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

                        let error : ErrorHandling = try! decoder.decode(ErrorHandling.self, from: responseData)


                        fail(error)
                    }
            }
         }
    }
    
    
    //MARK: - FAQ
    
    
    func getFAQCategory(success : @escaping (JSON) -> (),fail : @escaping(ErrorHandling) -> ()) {

        let url = URLSource.faq
        guard let token = defaults.object(forKey: "accessToken") else { return }

        AF.request(url, method: .get,encoding: JSONEncoding.default, interceptor: tokenInterceptor()).validate().responseJSON { response in

                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    print("JSON: \(json)")
                    success(json)

                case .failure(let error):
                    if let responseData = response.data {
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase

                        let error : ErrorHandling = try! decoder.decode(ErrorHandling.self, from: responseData)


                        fail(error)
                    }
         
                    print(error.localizedDescription)
                }

            }
         }
    
    
    func getFAQDetail(groupId : String,success : @escaping (JSON) -> (),fail : @escaping(ErrorHandling) -> ()) {

        let url = URLSource.faq  + "/" + groupId

        AF.request(url, method: .get,encoding: JSONEncoding.default, interceptor: tokenInterceptor()).validate().responseJSON { response in

                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    print("JSON: \(json)")
                    success(json)

                case .failure(let error):
                    if let responseData = response.data {
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase

                        let error : ErrorHandling = try! decoder.decode(ErrorHandling.self, from: responseData)


                        fail(error)
                    }
                    print(error.localizedDescription)
                }

            }
         }
    
    func getEventListDetail(inputFAQId id : String,success : @escaping (JSON) -> (),fail : @escaping(ErrorHandling) -> ()) {

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
                    if let responseData = response.data {
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase

                        let error : ErrorHandling = try! decoder.decode(ErrorHandling.self, from: responseData)


                        fail(error)
                    }
                    print(error.localizedDescription)
                }

            }
         }
    
    
    //MARK: - 회원 등급별 목록
    func getUserRank(success : @escaping (JSON) -> (),fail : @escaping(ErrorHandling) -> ()) {

        
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
                    if let responseData = response.data {
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase

                        let error : ErrorHandling = try! decoder.decode(ErrorHandling.self, from: responseData)


                        fail(error)
                    }
                    print(error.localizedDescription)
                }

            }
         }
    
    
    //MARK: - 광고
    
    func getAdsense(positionCd : String,success : @escaping (JSON) -> (),fail : @escaping(ErrorHandling) -> ()) {
        
    

        guard let userId = defaults.object(forKey: "userId") else { return }
       
        let url = URLSource.adsense + "/" + positionCd
   
        AF.request(url, method: .get,encoding: JSONEncoding.default,interceptor: tokenInterceptor()).validate().responseJSON { response in

                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    print("JSON: \(json)")
                    success(json)

                case .failure(let error):
                    if let responseData = response.data {
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase

                        let error : ErrorHandling = try! decoder.decode(ErrorHandling.self, from: responseData)


                       fail(error)
                    }
    
                }

            }
         }
    //MARK: - 유저 알림
    
    func getUserNoti(success : @escaping (JSON) -> (),fail : @escaping(ErrorHandling) -> ()) {

        
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
//                    if let responseData = response.data {
//                        let decoder = JSONDecoder()
//                        decoder.keyDecodingStrategy = .convertFromSnakeCase
//
//                        let error : ErrorHandling = try! decoder.decode(ErrorHandling.self, from: responseData)
//
//
//                        fail(error)
//                    }
                    print(error.localizedDescription)

                }

            }
         }
    
    
    func putUserNotiReading(messageNo : Int,success : @escaping (JSON) -> (),fail : @escaping(ErrorHandling) -> ()) {

        
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
                    if let responseData = response.data {
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase

                        let error : ErrorHandling = try! decoder.decode(ErrorHandling.self, from: responseData)


                        fail(error)
                    }
                    print(error.localizedDescription)
                }

            }
         }
    
    
    
    //MARK : - 초대 코드 발급
    
    func getInviteCode(success : @escaping (JSON) -> (),fail : @escaping(ErrorHandling) -> ()) {


        guard let userId = defaults.object(forKey: "userId") else { return }

        let url = URLSource.invite + "\(userId)"
        AF.request(url, method: .get,encoding: JSONEncoding.default, interceptor: tokenInterceptor()).validate().responseJSON { response in

                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    print("JSON: \(json)")
                    success(json)

                case .failure(let error):
                    if let responseData = response.data {
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase

                        let error : ErrorHandling = try! decoder.decode(ErrorHandling.self, from: responseData)


                        fail(error)
                    }
                    print(error.localizedDescription)
       
                }

            }
         }
    
    //MARK: - 쿠폰 / coupon
    func getUserCoupon(success : @escaping (JSON) -> (),fail : @escaping(ErrorHandling) -> ()) {

        
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
                    if let responseData = response.data {
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase

                        let error : ErrorHandling = try! decoder.decode(ErrorHandling.self, from: responseData)


                        fail(error)
                    }
                    print(error.localizedDescription)

                }

            }
         }
    
    
    //MARK: - 불만 사항 / Complain
    
    func postStoreComplain(storeId:String,contents: String, success : @escaping (JSON) -> (),fail : @escaping(ErrorHandling) -> ()) {

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
                    if let responseData = response.data {
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase

                        let error : ErrorHandling = try! decoder.decode(ErrorHandling.self, from: responseData)


                        fail(error)
                    }
                    print(error.localizedDescription)
                }

            }
         }
    
    
    //MARK: - 내역 / History
    
    func getHistory(type : String,searchMonth : String,success : @escaping (JSON) -> (),fail : @escaping(ErrorHandling) -> ()) {

        
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
                    if let responseData = response.data {
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase

                        let error : ErrorHandling = try! decoder.decode(ErrorHandling.self, from: responseData)


                        fail(error)
                    }
                    print(error.localizedDescription)

                }

            }
         }
    
    
    //MARK: - 인증 / CERT
    
    func postCertUser(success : @escaping (JSON) -> (),fail : @escaping(ErrorHandling) -> ()) {

        let url = URLSource.cert

        let header : HTTPHeaders = ["Content-Type" : "application/json"]

        AF.request(url, method: .post, encoding: JSONEncoding.default, headers: header).validate().responseJSON { response in


                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    print("JSON: \(json)")
                    success(json)
                    
                case .failure(let error):
                    if let responseData = response.data {
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase

                        let error : ErrorHandling = try! decoder.decode(ErrorHandling.self, from: responseData)


                        fail(error)
                    }
                    print(error.localizedDescription)
                }

            }
         }
    
    
}
