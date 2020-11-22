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
     "userId": "2a0f9a17175b488b8c1d31583e76fd1e",
     "email": "test9810@gmail.com",
     "nickname": "테스트9810",
     "useCount": 0,
     "ableCount": 0,
     "level": {
       "name": "이슬",
       "order": 0
     }
     */
    
    let userId : String
    let email : String
    let nickname : String
    let useCount : Int
    let ableCount : Int
    let levelName : String
    let levelOrder : Int
    

    
    
    
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
