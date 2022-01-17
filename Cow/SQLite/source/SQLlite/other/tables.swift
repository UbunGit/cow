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
        "name":"back_transaction",
        "create":
             """
                 CREATE TABLE "back_transaction" ( -- 回测记录表
                     "id"    INTEGER NOT NULL UNIQUE,
                     "scheme"    INTEGER, -- 方案id
                     "code"    TEXT, -- 股票代码
                     "bdate"    TEXT, -- 买入时间
                     "bprice"    NUMERIC, -- 买入价格
                     "bfree"    NUMERIC, -- 买入手续费
                     "bcount"    INTEGER, -- 买人数量
                     "sdate"    TEXT, -- 卖出时间
                     "sprice"    NUMERIC, -- 卖出价格
                     "sfree"    NUMERIC, -- 卖出手续费
                     "remark"    TEXT, -- 备注
                      PRIMARY KEY("id" AUTOINCREMENT)
                 );
            """
        
    ],
    [
        "name":"scheme",
        "create":
             """
                 CREATE TABLE IF NOT EXISTS "scheme" ( -- 策略表
                        "id"    INTEGER NOT NULL UNIQUE,
                        "template"    INTEGER, -- 参数id
                        "name"    TEXT NOT NULL, -- 参数名
                        PRIMARY KEY("id" AUTOINCREMENT)
                 );
            """
        
    ],
    [
        "name":"scheme_template",
        "create":
             """
                 CREATE TABLE IF NOT EXISTS "scheme_template" ( -- 策略模版表
                       "id"    INTEGER NOT NULL UNIQUE,
                       "name"    TEXT NOT NULL, -- 方案名
                       "des"    TEXT NOT NULL, -- 方案描述
                       PRIMARY KEY("id" AUTOINCREMENT)
                   );
            """
        
    ],
    [
        "name":"scheme_template_param",
        "create":
             """
               CREATE TABLE IF NOT EXISTS "scheme_template_param" ( -- 策略参数表
                           "id"    INTEGER NOT NULL UNIQUE,
                           "template_id"    INTEGER, -- 参数id
                           "name"    TEXT NOT NULL, -- 参数名
                           "key"    TEXT NOT NULL, -- 参数key
                           "defual"    TEXT NOT NULL, -- 默认值
                           "type"    TEXT NOT NULL, -- 类型
                           "des"    TEXT NOT NULL, -- 参数描述
                           PRIMARY KEY("id" AUTOINCREMENT)
               );
            """
        
    ],
    [
        "name":"scheme_template_param",
        "create":
             """
                CREATE TABLE IF NOT EXISTS "scheme_template_param" ( -- 策略参数表
                           "id"    INTEGER NOT NULL UNIQUE,
                           "template_id"    INTEGER, -- 参数id
                           "name"    TEXT NOT NULL, -- 参数名
                           "key"    TEXT NOT NULL, -- 参数key
                           "defual"    TEXT NOT NULL, -- 默认值
                           "type"    TEXT NOT NULL, -- 类型
                           "des"    TEXT NOT NULL, -- 参数描述
                           PRIMARY KEY("id" AUTOINCREMENT)
                       );
            """
        
    ],
    [
        "name":"loc_ochl",
        "create":
             """
               CREATE TABLE "loc_ochl" ( -- 本地ochl
                       "date"    TEXT,
                       "code"    TEXT,
                       "open"    NUMERIC,
                       "close"    NUMERIC,
                       "high"    NUMERIC,
                       "low"    NUMERIC,
                       "vol"    NUMERIC,
                       PRIMARY KEY("code","date")
               );
            """
        
    ],
    [
        "name":"back_trade",
        "create":
                    """
                    CREATE TABLE IF NOT EXISTS "back_trade" ( -- 回测记录
                            "id"    INTEGER NOT NULL UNIQUE,
                            "scheme_id"    INTEGER NOT NULL, -- 方案id
                            "date" TEXT NOT NULL, -- 时间
                            "type"    TEXT NOT NULL, -- 类型 0 股票 1 etf
                            "code"    TEXT NOT NULL, -- 代码code
                            "price"    NUMERIC NOT NULL, -- 价格
                            "dir"    INTEGER NOT NULL, -- 买卖方向 0 买入 1卖出
                            "count"    INTEGER NOT NULL, -- 数量
                            "sid"    INTEGER , -- 对冲ID 买入对应卖出订单 卖出对应买入订单
                            PRIMARY KEY("id" AUTOINCREMENT)
                        );
                    """
    ],
    [
        "name":"scheme_param",
        "create":
                    """
                            CREATE TABLE IF NOT EXISTS "scheme_param" ( -- 方案参数表
                                    "id"    INTEGER NOT NULL UNIQUE,
                                    "scheme_id"    INTEGER NOT NULL, -- 方案id
                                    "key"   TEXT NOT NULL, -- 参数key
                                    "value" TEXT NOT NULL, -- 参数值
                                    PRIMARY KEY("id" AUTOINCREMENT)
                                );
                    """
    ],
    [
        "name":"stock_price",
        "create":
     """
       CREATE TABLE IF NOT EXISTS "stock_price" ( -- 股票当前价格
         "code"    TEXT NOT NULL ,
         "price"   NUMERIC , -- 价格
         PRIMARY KEY("code")
        );
     """
    ],
    [
        "name":"stock_basic",
        "create":
     """
       CREATE TABLE IF NOT EXISTS "stock_basic" ( -- 股票名称
         "code"    TEXT NOT NULL ,
         "name"   NUMERIC , -- 价格
         PRIMARY KEY("code")
        );
     """
    ],
    
]

extension SqlliteManage{
    func sql_createTable(_ tablename:String) -> String? {
        if let dic = creatdTabledic.first(where: { $0["name"] ==  tablename })   {
            return dic["create"]
        }
        return ""
        
        
    }
}
