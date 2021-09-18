//
//  kirogi+stockbasic.swift
//  Cow
//
//  Created by admin on 2021/8/25.
//

import Foundation
extension SqlliteManage{
    
    
    
    func recommend(date:String,speed:Int=5, type:String="stock") throws -> [[String:Any]] {
        
        var tdate = Date()
        var sdate = ""
        if type == "stock"{
            tdate = date.date("yyyyMMdd")
            sdate = tdate.toString("yyyyMMdd")
        }else{
            tdate = date.date("yyyy-MM-dd")
            sdate = tdate.toString("yyyy-MM-dd")
        }
        let sql = """
                select t1.code, t2.name from kirogi\(type) as t1
                LEFT JOIN \(type)basic as t2
                ON t1.code = t2.code
                where t1.date='\(sdate)' AND t1.speed\(speed) != 'nan'
                ORDER BY t1.speed\(speed)  DESC
                LIMIT 10 OFFSET 0
                """
        print(sql)
        guard let datas = try db?.prepare(sql).to_dict() else {
            return []
        }
        return datas
    }
}

