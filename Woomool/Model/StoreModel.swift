//
//  StoreModel.swift
//  Woomool
//
//  Created by Dustin on 2020/10/23.
//  Copyright © 2020 Woomool. All rights reserved.
//

import Foundation


struct StoreModel {
    /*
     {
       "contact" : "0507-1318-8215",
       "storeId" : "NABNN8D06ZJ6436WN439",
       "operatingTime" : "매일 11:30 - 22:00",
       "latitude" : 37.5738731,
       "address" : "서울특별시 종로구 돈화문로11나길 31-9",
       "scope" : 0,
       "longitude" : 126.98976089999999,
       "image" : "",
       "name" : "청수당"
     }
     */
    
    let contact : String
    let storeId : String
    let operatingTime : String
    let address : String
    let scope : Int
    let image : String
    let name : String
    let latitude : Double
    let longitude : Double
    
    

    
    
    
}


struct BestStoreModel {
    /*
     {
       "orders": 4,
       "storeId": "IUWJ97P18W68S75YQR1E",
       "name": "앤트러사이트 강남점",
       "address": "서울 서초구 강남대로 405 1층",
       "scope": 1.4
     }
     */
    
    let orders : Int
    let storeId : String
    let name : String
    let address : String
    let scope : Double
    
    
    
    
}


struct StoreFindModel {
    /*
     {
       "storeId": "07FNNX4FXV9AC56T8D0V",
       "name": "디저트39 강남역점",
       "address": "서울 서초구 서초대로74길 23 서초타운트라팰리스 108호"
     }
     */
    
    let storeId : String
    let name : String
    let address : String
    
}
