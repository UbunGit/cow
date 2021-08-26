//
//  Kirogi.swift
//  apple
//  Kirogi 鸿雁 朝鲜 一种候鸟
//  Created by admin on 2021/7/9.
//

/**
 均线选股 当ma1>ma2时标记为买入
 */
import Foundation
import Magicbox
class Kirogi:SchemeProtocol{
//    var date:String = Date().toString("yyyyMMdd")
    var type:String = "etf"
    override init() {
        super.init()
    }
    var cachedata:[[String:Any]]? = nil
    
    override func recommend(_ data:String? = nil)throws -> [[String:Any]] {
//        if let cadata = cachedata {
//            return cadata
//        }
        
        cachedata =  try sm.recommend(date: date, speed: 5, type: type)
        return cachedata!
    }

    
}

