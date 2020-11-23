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


class Request {
    
    let defaults = UserDefaults.standard
    
    static let shared = Request()
    
    
     //MARK: - TOKEN
    func postUserToken(parameters : [String:Any], success : @escaping (JSON) -> () ) {


        let url = URLSource.token
        let headers : HTTPHeaders = ["Content-Type": "application/x-www-form-urlencoded",
                                     "Authorization" : "\(SecretKey.authorization)"]

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
            guard  let refresToken = defaults.object(forKey: "refreshToken") else { return }
            let params = ["grant_type": "refresh_token",
                          "scope" : "read+write",
                          "refresh_token" : refresToken]
            let headers : HTTPHeaders = ["Content-Type": "application/x-www-form-urlencoded",
                                         "Authorization" : "\(SecretKey.authorization)"]

            AF.request(url, method: .post, parameters: params,encoding:URLEncoding.default ,headers: headers)
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
    
    //MARK: - TERMS
    
    func getTerms(success : @escaping (JSON) -> () ) {

        
        let url = URLSource.terms
       
        
        AF.request(url, method: .get)
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
        guard let token = defaults.object(forKey: "accessToken") else { return }

        let header : HTTPHeaders = ["Content-Type" : "application/json",
                                    "authorization" : "Bearer \(token)" ]

        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: header).validate().responseJSON { response in


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
    
    func getUserInfo(success : @escaping (JSON) -> (),refreshSuccess: @escaping () -> ()) {

        guard let userId = defaults.object(forKey: "userId") else { return }
        guard let token = defaults.object(forKey: "accessToken") else { return }
        let header : HTTPHeaders = ["Authorization" : "Bearer \(token)"]
        let url = URLSource.user + "/" + "\(userId)"
        AF.request(url, method: .get,encoding: JSONEncoding.default, headers: header).validate().responseJSON { response in

                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    print("JSON: \(json)")
                    success(json)

                case .failure(let error):
                    print(error.localizedDescription)
                    if response.response?.statusCode == 401 {
                        
                        Request.shared.postUserRefreshToken { json in
                            refreshSuccess()
    
                            self.defaults.setValue(json["access_token"].stringValue, forKey: "accessToken")
                            self.defaults.setValue(json["refresh_token"].stringValue, forKey: "refreshToken")
                        }
                       
                        
                    }
                }

            }
         }
    
    func delUser(success : @escaping (JSON) -> (),refreshSuccess : @escaping() -> ()) {

        guard let userId = defaults.object(forKey: "userId") else { return }
        guard let token = defaults.object(forKey: "accessToken") else { return }
        let header : HTTPHeaders = ["Authorization" : "Bearer \(token)"]
        let url = URLSource.user + "/" + "\(userId)"
        AF.request(url, method: .delete,encoding: JSONEncoding.default, headers: header).validate().responseJSON { response in

                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    print("JSON: \(json)")
                    success(json)

                case .failure(let error):
                    if response.response?.statusCode == 401 {
                        
                        Request.shared.postUserRefreshToken { json in
                            refreshSuccess()
    
                            self.defaults.setValue(json["access_token"].stringValue, forKey: "accessToken")
                            self.defaults.setValue(json["refresh_token"].stringValue, forKey: "refreshToken")
                        }
                       
                        
                    }
                    print(error.localizedDescription)
                }

            }
         }
    
    func putChangeUserInfo(parameters : Parameters,success : @escaping (JSON) -> ()) {


        guard let token = defaults.object(forKey: "accessToken") else { return }
        let header : HTTPHeaders = ["Authorization" : "Bearer \(token)"]
        let url = URLSource.user
        AF.request(url, method: .put,parameters: parameters,encoding: JSONEncoding.default, headers: header).validate().responseJSON { response in

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
    
    func getStoreList(lat : Double,lon : Double,success : @escaping (JSON) -> (),refreshSuccess : @escaping() -> ()) {

        let url = URLSource.store
        guard let token = UserDefaults.standard.object(forKey: "accessToken") else { return }
        let header : HTTPHeaders = ["Authorization" : "Bearer \(token)"]
        
        let params = [
            "latitude" : lat,
            "longitude" : lon
        ]
        
        AF.request(url, method: .get,encoding: JSONEncoding.default, headers: header).validate().responseJSON { response in

                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    print("JSON: \(json)")
                    success(json)

                case .failure(let error):
                    if response.response?.statusCode == 401 {
                        
                        Request.shared.postUserRefreshToken { json in
                            refreshSuccess()
    
                            self.defaults.setValue(json["access_token"].stringValue, forKey: "accessToken")
                            self.defaults.setValue(json["refresh_token"].stringValue, forKey: "refreshToken")
                        }
                       
                        
                    }

                    print(error.localizedDescription)
                }

            }
         }
    
    
    func getBestStoreList(success : @escaping (JSON) -> ()) {

        let url = URLSource.storeBest
        guard let token = UserDefaults.standard.object(forKey: "accessToken") else { return }
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
    
    
    func getFindStoreList(inputStoreName Name : String,success : @escaping (JSON) -> ()) {
        let escapingCharacterSet: CharacterSet = {
            var cs = CharacterSet.alphanumerics
            cs.insert(charactersIn: "-_.~")
            return cs }()
        
       let encodingName =  Name.addingPercentEncoding(withAllowedCharacters: escapingCharacterSet)!
        
     
        let url = URLSource.storeFind + encodingName
        guard let token = UserDefaults.standard.object(forKey: "accessToken") else { return }
        let header : HTTPHeaders = ["Authorization" : "Bearer \(token)"]
        AF.request(url, method: .get,encoding: URLEncoding.default, headers: header).validate().responseJSON { response in

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
        guard let token = defaults.object(forKey: "accessToken") else { return }

        let header : HTTPHeaders = ["Content-Type" : "application/json",
                                    "authorization" : "Bearer \(token)" ]

        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: header).validate().responseJSON { response in


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
    
    func getStoreLookUp(storeId : String,success : @escaping (JSON) -> (),refreshSuccess : @escaping() -> ()) {

     
        let url = URLSource.store + "/" + storeId
        guard let token = UserDefaults.standard.object(forKey: "accessToken") else { return }
        let header : HTTPHeaders = ["Authorization" : "Bearer \(token)"]
        AF.request(url, method: .get, headers: header).validate().responseJSON { response in

                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    print("JSON: \(json)")
                    success(json)

                case .failure(let error):
                    print(error.localizedDescription)
                    
                    if response.response?.statusCode == 401 {
                        
                        Request.shared.postUserRefreshToken { json in
                            refreshSuccess()
    
                            self.defaults.setValue(json["access_token"].stringValue, forKey: "accessToken")
                            self.defaults.setValue(json["refresh_token"].stringValue, forKey: "refreshToken")
                        }
                       
                        
                    }

                }

            }
         }
    
    func postStoreUse(storeId:String, success : @escaping (JSON) -> (),refreshSuccess : @escaping() -> () ) {

        let url = URLSource.store
        guard let token = defaults.object(forKey: "accessToken") else { return }
        guard let userId = defaults.object(forKey: "userId") as? String else { return }
        let params = [
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
                        
                        Request.shared.postUserRefreshToken { json in
                            refreshSuccess()
    
                            self.defaults.setValue(json["access_token"].stringValue, forKey: "accessToken")
                            self.defaults.setValue(json["refresh_token"].stringValue, forKey: "refreshToken")
                        }
                       
                        
                    }
                    print(error.localizedDescription)
                }

            }
         }
    func putStoreScope(serialNo:Int,scope : Float, success : @escaping (JSON) -> (),refreshSuccess : @escaping() -> () ) {

        let url = URLSource.store
        guard let token = defaults.object(forKey: "accessToken") else { return }
       
        let params = [
              "scope": scope,
              "serialNo": serialNo
        ] as [String : Any]

        let header : HTTPHeaders = ["Content-Type" : "application/json",
                                    "authorization" : "Bearer \(token)" ]

        AF.request(url, method: .put, parameters: params, encoding: JSONEncoding.default, headers: header).validate().responseJSON { response in


                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    print("JSON: \(json)")
                    success(json)
                    
                case .failure(let error):
                    if response.response?.statusCode == 401 {
                        
                        Request.shared.postUserRefreshToken { json in
                            refreshSuccess()
    
                            self.defaults.setValue(json["access_token"].stringValue, forKey: "accessToken")
                            self.defaults.setValue(json["refresh_token"].stringValue, forKey: "refreshToken")
                        }
                       
                        
                    }
                    print(error.localizedDescription)
                }

            }
         }


    //MARK: - NOTICE
    
    
    func getNoticeList(success : @escaping (JSON) -> (),refreshSuccess: @escaping() -> ()) {

        let url = URLSource.notice
        guard let token = UserDefaults.standard.object(forKey: "accessToken") else { return }
        let header : HTTPHeaders = ["Authorization" : "Bearer \(token)"]
        AF.request(url, method: .get,encoding: JSONEncoding.default, headers: header).validate().responseJSON { response in

                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    print("JSON: \(json)")
                    success(json)

                case .failure(let error):
                    if response.response?.statusCode == 401 {
                        
                        Request.shared.postUserRefreshToken { json in
                            refreshSuccess()
    
                            self.defaults.setValue(json["access_token"].stringValue, forKey: "accessToken")
                            self.defaults.setValue(json["refresh_token"].stringValue, forKey: "refreshToken")
                        }
                       
                        
                    }

                    print(error.localizedDescription)
                }

            }
         }
    
    func getNoticeListDetail(inputNoticeId id : String,success : @escaping (JSON) -> ()) {

        let url = URLSource.notice + "/" + id
        guard let token = UserDefaults.standard.object(forKey: "accessToken") else { return }
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
    
    
    //MARK: - EVENT
    
    
    func getEventList(success : @escaping (JSON) -> (),refreshSuccess: @escaping()->()) {

        let url = URLSource.event
        guard let token = UserDefaults.standard.object(forKey: "accessToken") else { return }
        let header : HTTPHeaders = ["Authorization" : "Bearer \(token)"]
        AF.request(url, method: .get,encoding: JSONEncoding.default, headers: header).validate().responseJSON { response in

                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    print("JSON: \(json)")
                    success(json)

                case .failure(let error):
                    if response.response?.statusCode == 401 {
                        
                        Request.shared.postUserRefreshToken { json in
                            refreshSuccess()
    
                            self.defaults.setValue(json["access_token"].stringValue, forKey: "accessToken")
                            self.defaults.setValue(json["refresh_token"].stringValue, forKey: "refreshToken")
                        }
                       
                        
                    }

                    print(error.localizedDescription)
                }

            }
         }
    
    func getEventListDetail(inputEventId id : String,success : @escaping (JSON) -> ()) {

        let url = URLSource.event + "/" + id
        guard let token = UserDefaults.standard.object(forKey: "accessToken") else { return }
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
    
    //MARK: - Goods
    
    
    func getGoodsList(success : @escaping (JSON) -> ()) {

        
        guard let token = UserDefaults.standard.object(forKey: "accessToken") else { return }
        
        guard let userId = defaults.object(forKey: "userId") as? String else { return }
        let header : HTTPHeaders = ["Authorization" : "Bearer \(token)"]
        //let url = "http://211.250.213.5:21120/v1/goods/user/2a8d64cc27c94eab8c3738d528035e34"
        let url = URLSource.goods + userId
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
    
    
    func getPurchaseHistory(success : @escaping (JSON) -> ()) {

        
        guard let token = UserDefaults.standard.object(forKey: "accessToken") else { return }
        
        guard let userId = defaults.object(forKey: "userId") as? String else { return }
        let header : HTTPHeaders = ["Authorization" : "Bearer \(token)"]
        let url = URLSource.goodPurchase + userId
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
    
    func PostGoodsPurchase(couponId : String, goodsId : String, buyInfo : String,buyMethod : String , buyPrice : Int , success : @escaping (JSON) -> (),refreshSuccess: @escaping() -> ()) {

        
        guard let token = UserDefaults.standard.object(forKey: "accessToken") else { return }
        
        guard let userId = defaults.object(forKey: "userId") as? String else { return }
        
        let parameters = [
            "couponId": couponId,
            "goodsId": goodsId,
            "buyInfo": buyInfo,
            "buyMethod": buyMethod,
            "buyPrice": buyPrice,
            "userId": userId
        ] as [String : Any]
        
        
        let header : HTTPHeaders = ["Authorization" : "Bearer \(token)"]
        let url = URLSource.goodPurchase
        AF.request(url, method: .post,parameters: parameters,encoding: JSONEncoding.default, headers: header).validate().responseJSON { response in

                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    print("JSON: \(json)")
                    success(json)

                case .failure(let error):
                    if response.response?.statusCode == 401 {
                        
                        Request.shared.postUserRefreshToken { json in
                            refreshSuccess()
    
                            self.defaults.setValue(json["access_token"].stringValue, forKey: "accessToken")
                            self.defaults.setValue(json["refresh_token"].stringValue, forKey: "refreshToken")
                        }
                       
                        
                    }

                    print(error.localizedDescription)
                }

            }
         }
    
    
    //MARK: - FAQ
    
    
    func getFAQCategory(success : @escaping (JSON) -> (),refreshSuccess : @escaping() -> ()) {

        let url = URLSource.faq
        guard let token = defaults.object(forKey: "accessToken") else { return }
        let header : HTTPHeaders = ["Authorization" : "Bearer \(token)"]
        AF.request(url, method: .get,encoding: JSONEncoding.default, headers: header).validate().responseJSON { response in

                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    print("JSON: \(json)")
                    success(json)

                case .failure(let error):
                    if response.response?.statusCode == 401 {
                        
                        Request.shared.postUserRefreshToken { json in
                            refreshSuccess()
    
                            self.defaults.setValue(json["access_token"].stringValue, forKey: "accessToken")
                            self.defaults.setValue(json["refresh_token"].stringValue, forKey: "refreshToken")
                        }
                       
                        
                    }
                    print(error.localizedDescription)
                }

            }
         }
    
    
    func getFAQDetail(groupId : String,success : @escaping (JSON) -> (),refreshSuccess : @escaping() -> ()) {

        let url = URLSource.faq  + "/" + groupId
        guard let token = defaults.object(forKey: "accessToken") else { return }
        let header : HTTPHeaders = ["Authorization" : "Bearer \(token)"]
        AF.request(url, method: .get,encoding: JSONEncoding.default, headers: header).validate().responseJSON { response in

                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    print("JSON: \(json)")
                    success(json)

                case .failure(let error):
                    if response.response?.statusCode == 401 {
                        
                        Request.shared.postUserRefreshToken { json in
                            refreshSuccess()
    
                            self.defaults.setValue(json["access_token"].stringValue, forKey: "accessToken")
                            self.defaults.setValue(json["refresh_token"].stringValue, forKey: "refreshToken")
                        }
                       
                        
                    }
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
                        
                        Request.shared.postUserRefreshToken { json in
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
                        
                        Request.shared.postUserRefreshToken { json in
                            refreshSuccess()
    
                            self.defaults.setValue(json["access_token"].stringValue, forKey: "accessToken")
                            self.defaults.setValue(json["refresh_token"].stringValue, forKey: "refreshToken")
                        }
                       
                        
                    }
                }

            }
         }
    
    
    func putUserNotiReading(serialNo : Int,success : @escaping (JSON) -> (),refreshSuccess: @escaping() -> ()) {

        
        guard let token = UserDefaults.standard.object(forKey: "accessToken") else { return }

        let header : HTTPHeaders = ["Authorization" : "Bearer \(token)"]
        let url = URLSource.userNoti + "\(serialNo)"
        AF.request(url, method: .put,encoding: JSONEncoding.default, headers: header).validate().responseJSON { response in

                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    print("JSON: \(json)")
                    success(json)

                case .failure(let error):
                    print(error.localizedDescription)
                    if response.response?.statusCode == 401 {
                        
                        Request.shared.postUserRefreshToken { json in
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
                        
                        Request.shared.postUserRefreshToken { json in
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
                        
                        Request.shared.postUserRefreshToken { json in
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
                        
                        Request.shared.postUserRefreshToken { json in
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
                        
                        Request.shared.postUserRefreshToken { json in
                            refreshSuccess()
    
                            self.defaults.setValue(json["access_token"].stringValue, forKey: "accessToken")
                            self.defaults.setValue(json["refresh_token"].stringValue, forKey: "refreshToken")
                        }
                       
                        
                    }
                }

            }
         }
    
}
