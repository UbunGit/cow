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
import Alamofire
class Kirogi:SchemeProtocol{

    var type:String = "etf"
    var speed:Int = 5

    override init() {
        super.init()
        self.name = "Kirogi"
        self.signal = 0.98
    }
    var cachedata:[[String:Any]]? = nil

    override func recommend(_ data:String? = nil ,didchange:@escaping ([[String:Any]])->()) {
        
        if let cadata = cachedata {
            didchange(cadata)
            return
        }
        let url = "\(baseurl)/select"
        let speed = 5
        let param = ["sql":"""
            select t1.code,t1.sort,t1.count,t1.signal, t2.name
            from kirogi_\(type)_signal_\(speed) as t1
            LEFT JOIN \(type)basic as t2
            ON t1.code = t2.code
            where t1.date='\(date)' and t1.signal>=\(signal)
            ORDER BY t1.signal  DESC
            """]
        
        AF.request(url, method: .post, parameters: param,encoder:JSONParameterEncoder.default)
            .responseModel([[String:Any]].self) { result in
                switch result{
                case .success(let value):
                    self.cachedata = value
                    didchange(value)
                case .failure(_):
                    break
                }
            }
    }

    
}

