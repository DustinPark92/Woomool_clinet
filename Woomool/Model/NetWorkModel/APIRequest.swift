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
    
    
     //MARK: - TOKEN , 토큰
    
    
    // 1. 토큰 요청 - 로그인 , 회원가입 시 진행
    func postUserToken(userInfoArray : Array<String>, success : @escaping (JSON) -> () , fail : @escaping(String) -> ()) {


        let url = URLSource.token
        
        
        let parameters = ["grant_type": "password",
                      "scope" : "app",
                      "username" : userInfoArray[0],
                      "password" : userInfoArray[1]]
    
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
                    print("JSON: \(json),\(response.response?.statusCode)")
                    
                    
                    
                    switch response.response?.statusCode {
                    case 200:
                        success(json)
                    case 400:
                        fail("이메일이나 비밀번호를 확인해주세요.")
                    default:
                        break
                    }
                    
                    
                    
                    

                    
                case .failure(let error):
                    
                    print(error.localizedDescription)
                }

         }
    }
        
    
    // 2. 리프레쉬 토큰 요청 - 토큰 만료 시 진행.
    func postUserRefreshToken(success : @escaping (JSON) -> () ) {


            let url = URLSource.token
            guard  let refreshToken = defaults.object(forKey: "refreshToken") else { return }
            
            let params = ["grant_type": "refresh_token",
                          "scope" : "app",
                          "refresh_token" : refreshToken]
        
            let credentialData = "\(SecretKey.id):\(SecretKey.authorization)".data(using: String.Encoding.utf8)!
            let base64Credentials = credentialData.base64EncodedString(options: [])
        
            let headers : HTTPHeaders =
                ["Content-Type": "application/x-www-form-urlencoded",
                "Authorization" : "Basic \(base64Credentials)"]
        
        print("리프레시 \(refreshToken),\(SecretKey.authorization),\(base64Credentials)")

        AF.request(url, method: .post, parameters: params,encoding:URLEncoding.default ,headers: headers)
                .responseJSON
                 { response in
          
                    switch response.result {
                    case .success(let value):
                        let json = JSON(value)
                        //print(json)
                        print("JSON: \(json)")
                            
                        
                    if response.response?.statusCode == 200 || response.response?.statusCode == 201 {
                            success(json)
                    }
  
                        

                    case .failure(let error):
                        print(error.localizedDescription)
                    }

             }
    
    }
    
    //MARK: - TERMS , 약관
    /*
     약관은 변경 사항이 있을 시 마다 정보 동의를 받아야 하며,
     유저 정보에 Array형식으로 내려온다.
     */
    
    // 1. 약관 정보 동의 Post
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
    
    
    //2. 약관 정보 가져오기 : 설정에서 탭에서 정보 조회 시 사용
    
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
    
    
    //1. 유저 회원 등록
    func postUserSignUp(userInfoArray : Array<String>,transData : String, success : @escaping (JSON) -> () ) {

        let url = URLSource.user
        
        let parameters : [String : Any] =
                  [
                      "email": userInfoArray[0],
                      "inviteCd": userInfoArray[4],
                      "nickname": userInfoArray[3],
                      "password": userInfoArray[2],
                       "transData" : transData
                      
                  ]

        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().responseJSON { response in


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
    
    
    //2. 유저 SNS 회원 등록
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
    
    
    //3. 유저 로그인
    func postUserLogin(userInfoArray : Array<String>, success : @escaping (JSON) -> (),fail : @escaping(ErrorHandling) -> ()) {

        let url = URLSource.login
        
        let parameters = [
            "email": userInfoArray[0],
            "password": userInfoArray[1]
            
        ]
 
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, interceptor: tokenInterceptor()).validate().responseJSON { response in


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
    
    
    //4. SNS 로그인
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
        
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
                            fail(error)
                        }
                       
                    }
                }

            }
         }
    
    
    //5. 유저 정보 조회
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
    
    
    
    //6. 유저 개인 정보 조회
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
    
    
    // 7. 유저 우물 환경 조회
    func getUserEnviroment(success : @escaping (JSON) -> (),fail : @escaping(ErrorHandling) -> ()) {
        
    

        guard let userId = defaults.object(forKey: "userId") else { return }
        let url = URLSource.envir + "\(userId)"
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
    
    // 8. 유저 비밀 번호 찾기
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
    
    
    // 9. 유저 정보 삭제 - 탈퇴 이유를 함께 보내야 한다.
    func delUser(reason : String,success : @escaping (JSON) -> (),fail : @escaping(ErrorHandling) -> ()) {

        guard let userId = defaults.object(forKey: "userId") else { return }
        
        let params = ["reason" : reason]
        


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
    
    
    // 10. 유저 정보 변경 - 유저 정보 변경 사항이 없으면 빈 값("")으로 보낸다.
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

    
    //MARK: - STORE / 상점 , 카페 , 상품
    
    
    
    // 1. 카페 조회
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
    
    //2. 카페의 상세 정보 - 유저가 지도를 클릭하여 카페 상세 정보를 조회 하였을때
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
    
    
    //3. 베스트 우물 카페 리스트를 조회 한다.
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
    
    //4. 카페 찾기 , 파트너로 등록 된 카페를 찾는다. 수질 관리 요청 등 사용에 이용
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
    
    
    //5. 카페 등록 요청 , 유저가 파트너로 이용 할 카페를 등록 한다.
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
    
    
    
    //6. QR 조회 - 유저가 QR코드로 카페 조회시에 사용
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
    
    
    //7. QR 사용 , 유저가 QR코드로 조회 된 카페의 정보로 이용권을 사용 한다.
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
    
    //8. QR 별점 , 카페 이용 후 별점 남기기
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


    //MARK: - NOTICE , 공지 사항
    
    
    //1. 공지 사항
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
    //MARK: - Goods , 상품 관련
    
    
    
    //1. 상품 리스트 조회
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
    
    //2. 상품 구입 내역
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
    
    
    //MARK: - FAQ , 자주 묻는 질문
    
    
    
    //1. 자주 묻는 질문 리스트
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
    
    //2. 자주 묻는 질문 상세
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
    
    
    //MARK: - 회원 등급별 목록
    
    
    //1. 회원 등급 조회 , 유저의 회원 등급 조회
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
    
    
    //1. 광고 정보 가져오기.
    
    func getAdsense(positionCd : String,success : @escaping (JSON) -> (),fail : @escaping(ErrorHandling) -> ()) {
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
    
    /*
     메인 화면 HomeViewController에서의 유저 알림 조회는
     유저 정보 조회 시에 내려 온다.
     */
    
    
    //1. 유저 알림 조회
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
    
    //2. 유저가 유저 알림을 읽었을때
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
    
    
    //1. 초대 코드 조회
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
    
    
    //1. 유저 쿠폰 조회
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
    
    
    //1. 수질 관리 요청
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
    
    
    //1. 유저 내역 , 전체 이용 내역 , 이용권 사용 내역 , 구매 내역 조회
    
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
    
    
    //1. 본인 인증
    
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
