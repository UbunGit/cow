//
//  StockBasic.swift
//  Cow
//  股票model
//  Created by admin on 2021/8/9.
//

import Foundation
import Magicbox
import Alamofire
import HandyJSON
import SQLite


let id = Expression<Int64>("id")


public struct StockBasic:HandyJSON, Codable{

    var name:String = ""
    var code:String = ""
    var area:String = ""
    var industry:String = ""
    var market:String = ""
    var changeTime:String = "\(Date().mb_toString("yyyy-MM-dd"))"
    public init() {
        
    }

}

extension StockBasic{
    
    static func api_update(finesh:@escaping (BaseError?)->()){
        let url = "\(baseurl)/store/basic"
        let param = ["changeTime":"","keyword":""]
 
        AF.request(url, method: .get, parameters: param) { urlRequest in
            urlRequest.timeoutInterval = 50
        }.responseModel([StockBasic].self) { result in
            switch result{
            case .failure(let error):
                finesh(BaseError.init(code: -1, msg: error.msg))
            case .success(let value):
                do{
                    _ = try sm.mutableinster(
                        table: "stockbasic",
                        column: ["name","code","area","industry","market","changeTime"],
                        datas: value.map{$0.toJSON() ?? [:]})
                }catch{
                    finesh(BaseError.init(code: -1, msg: error.localizedDescription))
                }
             
                finesh(nil)
            }
        }
    }
}
extension StockBasic:SqliteProtocol{
    
    public init(row: Row) {
        name = row[Expression<String>.init("name")]
        code = row[Expression<String>.init("code")]
        area = row[Expression<String>.init("area")]
        industry = row[Expression<String>.init("industry")]
        market = row[Expression<String>.init("market")]
        changeTime = row[Expression<String>.init("changeTime")]
        
    }
    public var table: Table? {
        
        
        let  e_name = Expression<String>.init("name")
        let  e_code = Expression<String>.init("code")
        let  e_area = Expression<String>.init("area")
        let  e_industry = Expression<String>.init("industry")
        let  e_market = Expression<String>.init("market")
        let  e_changeTime = Expression<String>.init("changeTime")
        
        let _table = self.createTable(tableName: "\(type(of: self))".lowercased(), block: { builder in
            builder.column(e_code, primaryKey:true)
            builder.column(e_name)
            builder.column(e_area)
            builder.column(e_industry)
            builder.column(e_market)
            builder.column(e_changeTime)
        })
        return _table
        
    }
}

