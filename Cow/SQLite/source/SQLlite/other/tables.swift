//
//  rel_transaction.swift
//  Cow
//
//  Created by admin on 2021/9/6.
//

import Foundation
let creatdTabledic =
    [
        [
            "name":"rel_transaction",
            "create":
                """
                    CREATE TABLE "rel_transaction" (
                    "id"    INTEGER NOT NULL UNIQUE,
                    "userid"    INT NOT NULL,
                    "code"    TEXT NOT NULL,
                    "type"    INTEGER,
                    "bcount"    INTEGER,
                    "bdate"    TEXT NOT NULL,
                    "bprice"    NUMERIC NOT NULL,
                    "bfree"    NUMERIC,
                    "sdate"    TEXT,
                    "sprice"    NUMERIC,
                    "sfree"    NUMERIC,
                    "target" NUMERIC,
                    "plan"    TEXT,
                    "remarks"  TEXT,
                    PRIMARY KEY("id" AUTOINCREMENT)
                );
            """
        ],
        [
            "name":"scheme",
            "create":
             """
                    CREATE TABLE "scheme" ( -- 方案表
                    "id"    INTEGER NOT NULL UNIQUE, -- id
                    "name"    TEXT NOT NULL,  -- 方案名
                    "count"    TEXT , -- 个数语句
                    "select"    TEXT , -- 结果语句
                    "where"    TEXT , -- 条件语句
                    "order"    TEXT, -- 排序语句
                    "limit"    TEXT, -- 分页语句
                    "remarks"  TEXT, -- 备注
                    PRIMARY KEY("id" AUTOINCREMENT)
                );
            """
              
        ]
  
]

extension SqlliteManage{
    func sql_createTable(_ tablename:String) -> String? {
        if let dic = creatdTabledic.first(where: { $0["name"] ==  tablename })   {
            return dic["create"]
        }
        return ""
        
        
    }
}
