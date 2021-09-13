//
//  Cerebro.swift
//  apple
//  交易中心
//  Created by admin on 2021/7/9.
//

import Foundation
import Magicbox

typealias CerebroQualify = (_ item:[String:Any])->(Bool)

public class Cerebro {
  
    var loglevel = true // 是否打印日志
    var key = "" // 回测唯一标识
    
    
    // 可选参数
    var date = "date" // 时间字段
    var signal = "signal" // 信号量字段
    //
    
    init(_ key:String) {
        self.key = key
    }
    
    func setup() throws {
       try createTableIfNotExite()
    }
    
    func run(
        datas:[[String:Any]],
        scheme:[Cerebro],
        bqualify:[CerebroQualify] = [],
        squalify:[CerebroQualify] = []
    ) throws {
        if datas.count <= 0 {
            throw BaseError(code: -1, msg: "没有可回测的数据")
        }
        var testData = datas
        testData.sort{ $0[date].string()>$1[date].string() }
        for item in testData {
            
        }
        
    }
    
    
    

//    public func buy(
//        code:String,
//        date:Date,
//        price:Double,
//        count:Int,
//        free:((Double)->(Double))? = nil
//    ) throws {
//
//        let money:Double = price * Double(count)
//        let nfree:Double = Double((free == nil) ? 0.0 : free!(money))
//
//        bslines.append(BSLine(
//                        code: code,
//                        bDate: date,
//                        sDate: nil,
//                        bPrice: price,
//                        sPrice: nil,
//                        count: count,
//                        bFree: nfree,
//                        sFree: nil
//        ))
//
//
//    }
    
//    public func seller(
//        code:String,
//        price:Double,
//        date:Date,
//        free:((Double)->(Double))? = nil) throws
//    {
//        let allcount = allcount(code: code)
//        if allcount <= 0 {
//            loging("持仓不足")
//            throw BaseError(code: -1, msg: "持仓不足")
//        }
//        guard let minline = minimumbs(code: code) else {
//            loging("无持仓")
//            throw BaseError(code: -1, msg: "无持仓")
//        }
//        let money = (Double(minline.count) * price)
//        let nfree:Double = Double((free == nil) ? 0.0 : free!(money))
//        minline.sDate = date
//        minline.sPrice = price
//        minline.sFree = nfree
//
//    }
    
    
}
// db
public extension Cerebro{
    func createTableIfNotExite() throws {
        let sql = """
                CREATE TABLE  IF NOT EXISTS "Cerebro_transaction" (
                "id"    INTEGER NOT NULL UNIQUE,
                "key"    INT NOT NULL,
                "code"    TEXT NOT NULL,
                "name"    TEXT NOT NULL,
                "count"    INTEGER,
                "bdate"    TEXT NOT NULL,
                "bprice"    NUMERIC NOT NULL,
                "bfree"    NUMERIC,
                "sdate"    TEXT,
                "sprice"    NUMERIC,
                "sfree"    NUMERIC
                PRIMARY KEY("id" AUTOINCREMENT)
            """
        try sm.db?.execute(sql)
    }
}


public extension Cerebro{
    func loging(_ msg:Any) {
        if loglevel {
            print("Cerebro:\(msg)")
        }
    }
}
