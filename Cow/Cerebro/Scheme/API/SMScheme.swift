//
//  SMScheme.swift
//  Cow
//
//  Created by admin on 2021/11/25.
//

import Foundation
extension SqlliteManage{
    
    //获取某日股票收盘价
    func closePrice(code:String,date:String)->Double{
        // 如果当前日期没有价格返回第一次有价格的价格
        let sql = """
        SELECT close FROM loc_ochl
        WHERE date <= '\(date)' and code='\(code)'
        ORDER BY date DESC
        LIMIT 1 OFFSET 0
        """
        if let date = sm.select(sql).first{
            return date["close"].double()
        }else{
            let sql1 = """
            select * from loc_ochl
            where code='\(code)'
            ORDER BY date
            LIMIT 1 OFFSET 0
            """
            if let date = sm.select(sql1).first{
                return date["close"].double()
            }else{
                return 0
            }
        }
    }
    
    // 获取某日资产
    func scheme_property(_ schemeId:Int,date:String)->Double{
        var sum:Double = 0
        // 获取已卖出资产
        let beginsql = """
            SELECT sum((sprice-price)/price) sum FROM
            (
                SELECT t0.*,t1.date sdate,t1.price sprice FROM  back_trade t0
                LEFT JOIN
                (
                    SELECT * FROM  back_trade
                    WHERE  dir=1
                ) t1 ON t1.sid = t0.id
                WHERE t0.dir = 0 and t0.date<'\(date)'
            )
            WHERE scheme_id=\(schemeId) and (sdate is NOT NULL AND sdate<='\(date)')
            """
        if let beginyied = sm.select(beginsql).first{
            sum += beginyied["sum"].double()
        }
        
        // 获取未卖出的资产
        let sql = """
        SELECT * FROM
            (
            select t1.date date,t2.date sdate,t1.code code,t1.price price
            from back_trade t1
            LEFT JOIN
                (
                select * from back_trade
                WHERE dir =1  and scheme_id='\(schemeId)'
                ) t2 ON t2.sid=t1.id
            WHERE t1.dir=0 and t1.scheme_id='\(schemeId)'
            ) as t
        WHERE  t.date<'\(date)'
        AND (t.sdate>'\(date)' OR t.sdate ISNULL)
        """
        
        let untrades = sm.select(sql)
        untrades.forEach { item in
            let code = item["code"].string()
            let price = item["price"].double()
            let close = sm.closePrice(code: code, date: date)
            let of = ((close/price) - 1)
            sum += of
        }
        return sum
    }
    
    
}
