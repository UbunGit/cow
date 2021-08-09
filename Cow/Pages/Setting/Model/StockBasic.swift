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


class StockBasic:HandyJSON, Codable,SqliteProtocol{

    var name:String = ""
    var code:String = ""
    var area:String = ""
    var industry:String = ""
    var market:String = ""
    var changeTime:String = ""
    
    func expression(keyPath:AnyKeyPath, column:String) -> Setter? {
        
        guard let value = self[keyPath: keyPath]  else {
            return nil
        }
//        let type = value.self
        typealias UnderlyingType = value.self
        
        let expression = Expression<value.self>(column)
   
        let srtt = expression <- (value as! Int64)
        try? db?.run((table?.insert(srtt))!)
        return srtt
    }
    
    
    required init() {
        
    }
    
}

extension StockBasic{
    
    static func api_update(finesh:@escaping (BaseError?)->()){
        let url = "\(baseurl)/store/basic"
        let param = ["changeTime":"","keyword":""]
        AF.request(url, method: .get, parameters: param) { urlRequest in
            urlRequest.timeoutInterval = 15
        }.responseModel([StockBasic].self) { result in
            switch result{
            case .failure(let error):
                finesh(BaseError.init(code: -1, msg: error.msg))
            case .success(let value):
//                try? StockBasic().insert(setters: <#T##[Setter]#>)
                
                finesh(nil)
            }
        }
        
    }
}
extension StockBasic{
  
}
