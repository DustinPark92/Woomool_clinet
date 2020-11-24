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
     "operTime" : "월요일 09:00 - 22:00",
     "scope" : 4.5,
     "latitude" : 37.4987858,
     "name" : "앤트러사이트 강남점",
     "address" : "서울 서초구 강남대로 405 1층",
     "storeId" : "V7T1P08C895SPDJ78IZ8",
     "contact" : "02-6402-2929",
     "longitude" : 127.02671170000001,
     "image" : "",
     "scopeColor" : "INDIGO",
     "distance" : "1.5km",
     "fresh" : "Y"
     }
     */
    
    let contact : String
    let storeId : String
    let operTime : String
    let address : String
    let scope : Int
    let image : String
    let name : String
    let latitude : Double
    let longitude : Double
    let scopeColor : String
    let distance : String
    let fresh : String

    
    
    
}


class PickUpStoreModel {
        
        var contact : String = ""
    var storeId : String = ""
    var operTime : String = ""
    var address : String = ""
    var scope : Double = 0
    var image : String = ""
    var name : String = ""
    var latitude : Double = 0.0
    var longitude : Double = 0.0
    var scopeColor : String = ""
    var distance : String = ""
    var fresh : String = ""

        
  
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


class StoreLookUpModel {
    var storeId : String = ""
    var name : String = ""
}
