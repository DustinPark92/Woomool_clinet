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
     "types" : "K",
     "nickname" : "박병호",
     "joinMonth" : "2021-01",
     "email" : "p4569@naver.com",
     "statusMessage" : "N",
     "buyCount" : 0,
     "userId" : "587b39f807a8449fade9ef6af0a7690a",
     "level" : {
       "levelId" : "LV1",
       "orders" : 1,
       "name" : "이슬"
     },
     "useCount" : 0,
     "terms" : [

     ],
     "remCount" : 0
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
    let statusMessage : String
    

    
    
    
}


class userAddtionalData {
    var birth = ""
    var sex = ""
    var name = ""
    var transData = ""
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
    let standard : String
    
    
    
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


class UserPrivacy {
    /*
     "name" : "박병호",
     "email" : "u@u.com",
     "dob" : "20140101",
     "nickname" : "캬오캬오",
     "sex" : "1"
     */
    
    var name = ""
    var email = ""
    var dob = ""
    var nickname = ""
    var sex = ""
    
}
