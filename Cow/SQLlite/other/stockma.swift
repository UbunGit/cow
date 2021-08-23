//
//  stockma.swift
//  Cow
//
//  Created by admin on 2021/8/23.
//

import Foundation
import Magicbox
// StockMA
public extension SqlliteManage{
    func create_stockma() throws{
        let sql = """
        CREATE TABLE IF NOT EXISTS "stockma" -- 股票均线
     (
        "date" TEXT, -- 时间
        "code" TEXT, -- 股票代码
        "ma5" NUMERIC, -- 开盘价
        "ma10" NUMERIC, -- 收盘价
        "ma20" NUMERIC, -- 最高价
        "ma30" NUMERIC, -- 最低价
        "ma60" NUMERIC, -- 交易量
        PRIMARY KEY("code","date")
     )
     """
        print(sql)
        try db?.execute(sql)
    }
    
  
    
   
}
