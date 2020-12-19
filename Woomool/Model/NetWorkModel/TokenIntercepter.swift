//
//  TokenIntercepter.swift
//  Woomool
//
//  Created by Dustin on 2020/12/05.
//  Copyright © 2020 Woomool. All rights reserved.
//

import Alamofire
import SwiftyJSON

class tokenInterceptor : RequestInterceptor {
    
    let defaults = UserDefaults.standard
    
    
}


extension tokenInterceptor {
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        
        var urlRequest = urlRequest
        let deviceVersion = (UIDevice.current.systemVersion as NSString).floatValue
        let deviceName = UIDevice.modelName

        
        guard let accessToken = UserDefaults.standard.object(forKey: "accessToken") as? String else { return }

        urlRequest.allHTTPHeaderFields = [
            "authorization" : "Bearer \(accessToken)",
            "x-woomool-os" : "I",
            "x-woomool-device" : "\(deviceName),\(deviceVersion)",
            "x-woomool-id" : "com.woomool.ios"
        ]
        
        print(accessToken)
        
        completion(.success(urlRequest))
        
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        if request.response?.statusCode == 401 {
            APIRequest.shared.postUserRefreshToken { json in
                        completion(.retry)
            }

        
        } else {
            completion(.doNotRetry)
        }
        
        
    }
}
