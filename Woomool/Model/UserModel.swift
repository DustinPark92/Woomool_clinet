//
//  userModel.swift
//  Woomool
//
//  Created by Dustin on 2020/10/11.
//  Copyright © 2020 Woomool. All rights reserved.
//

import Foundation


struct UserModel {
    /*
     JSON: {
       "remCount" : 0,
       "useCount" : 0,
       "userId" : "1c0b23efe07143968585ffdef3c02a84",
       "buyCount" : 0,
       "level" : {
         "orders" : 1,
         "name" : "이슬",
         "levelId" : "LV1"
       },
       "email" : "p4569@naver.com",
       "joinMonth" : "2020-11",
       "nickname" : "테스토오호"
     }
     */
    
    let userId : String
    let email : String
    let nickname : String
    let types : String
    let useCount : Int
    let remCount : Int
    let buyCount : Int
    let levelName : String
    let levelOrder : Int
    let levelId : String
    let joinMonth : String
    

    
    
    
}


struct UserRankModel {
    /*
     "levelId": "L1",
     "name": "이슬",
     "orders": 1,
     "benefits": "",
     "userStatus": "NOW",
     "userRate": 0
     */
    
    let levelId : String
    let name : String
    let orders : Int
    let benefits : String
    let userStatus : String
    let userRate : Int
    
    
    
}


struct UserEnviroment {
    /*
     {
       "carbon": "string",
       "totalCount": 0,
       "useCount": 0
     }
     */
    
    let carbon : String
    let totalCount : Int
    let userCount : Int
    
    
}
