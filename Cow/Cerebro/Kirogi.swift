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
    override init() {
        super.init()
    }
    var cachedata:[[String:Any]]? = nil
    
    func loadrecommend()  {
        let url = "\(baseurl)/select"
        let speed = 5
        let param = ["sql":"""
                            select t1.code, t2.name from kirogi\(type) as t1
                            LEFT JOIN \(type)basic as t2
                            ON t1.code = t2.code
                            where t1.date='\(date)' AND t1.speed\(speed) != 'nan'
                            ORDER BY t1.speed\(speed)  DESC
                            LIMIT 10 OFFSET 0
            """]
        
        AF.request(url, method: .post, parameters: param,encoder:JSONParameterEncoder.default)
            .responseModel([[String:Any]].self) { result in
                switch result{
                case .success(let value):
                    self.cachedata = value
                case .failure(_):
                    break
                }
            }
    }
    
    override func recommend(_ data:String? = nil)throws -> [[String:Any]] {
        if let cadata = cachedata {
            return cadata
        }
        loadrecommend()
        return []
    }

    
}

