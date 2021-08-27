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
    var changeTime:String = "\(Date().toString("yyyy-MM-dd"))"
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
                finesh(BaseError.init(code: -1, msg: error.localizedDescription))
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


