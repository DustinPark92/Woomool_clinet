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
       "serialNo" : 13,
       "useCount" : 1,
       "store" : {
         "storeId" : "V7T1P08C895SPDJ78IZ8",
         "name" : "앤트러사이트 강남점"
       },
       "useDate" : "2020-11-24"
     }
     */
    let historyNo : Int
    let useCount : Int
    let storeId : String
    let name : String
    let useDate : String


}
