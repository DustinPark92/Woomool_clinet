//
//  HistoryModel.swift
//  Woomool
//
//  Created by Dustin on 2020/11/23.
//  Copyright © 2020 Woomool. All rights reserved.
//

import Foundation



struct HistoryAllModel {
    /*
     {
       "name" : "15회 이용권",
       "countPrice" : 9900,
       "date" : "2020-11-23",
       "serialNo" : 16,
       "types" : "G"
     },

     
     */
    
    let name : String
   
    let count : Int
    let countUnit : String
    
    let price : Int
    let priceUnit : String
    
    let date : String
    let image : String
    let historyNo : Int
    
    
    
}


struct HistoryGoodsModel {
    let historyNo : Int
    let date : String
    let goodsId : Int
    let name : String
    let price : Int
    let image : String
    let priceUnit : String
    /*
     {
       "goods" : {
         "name" : "15회 이용권",
         "goodsId" : "GD20201111143844999"
       },
       "historyNo" : 170,
       "price" : 100,
       "date" : "2020-12-19",
       "image" : null,
       "priceUnit" : "원"
     }
     */
}


struct HistoryStoreModel {
    /*
     {
       "date" : "2020-12-25",
       "countUnit" : "-",
       "image" : "http:\/\/211.250.213.5\/images\/my_usagehistory_use.png",
       "store" : {
         "storeId" : "7MKNPBMT62XV0XMB7A11",
         "name" : "카페살렘"
       },
       "count" : 1,
       "historyNo" : 1
     }
     */
    let historyNo : Int
    let count : Int
    let storeId : String
    let name : String
    let date : String
    let countUnit : String
    let image : String


}
