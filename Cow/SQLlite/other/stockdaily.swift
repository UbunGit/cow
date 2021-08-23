//
//  stockdaily.swift
//  Cow
//
//  Created by admin on 2021/8/23.
//

import Foundation

// StockDaily
public extension SqlliteManage{
    func create_stockdaily() throws{
        let sql = """
        CREATE TABLE IF NOT EXISTS "stockdaily" -- 股票日数据
     (
        "date" TEXT, -- 时间
        "code" TEXT, -- 股票代码
        "open" NUMERIC, -- 开盘价
        "close" NUMERIC, -- 收盘价
        "high" NUMERIC, -- 最高价
        "low" NUMERIC, -- 最低价
        "vol" NUMERIC, -- 交易量
        "amount" NUMERIC, -- 交易价
        PRIMARY KEY("code","date")
     )
     """
        print(sql)
        try db?.execute(sql)
    }
    
    func delete_stockdaily(code:String) throws {
        let sql = """
         delete FROM  "stockdaily"
         where code = '\(code)'
         """
        print(sql)
        try db?.execute(sql)
    }
}
