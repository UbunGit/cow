//
//  stockdaily+stockma.swift
//  Cow
//
//  Created by admin on 2021/8/23.
//

import Foundation

extension SqlliteManage{
    
    func select_stockdaily_stockma(
        fitter:String = "",
        orderby:[String] = [],
        limmit:NSRange? = nil,
        isasc:Bool = true
    ) throws -> [[String:Any]] {
        var sql = """
            SELECT * from stockdaily as t1
            LEFT JOIN stockma as t2
            ON t1.code = t2.code AND t1.date = t2.date
            """
        if fitter.count>0 {
            sql.append("""
           
           WHERE \(fitter)
           """)
        }
        if orderby.count>0 {
            sql.append("""
            
            ORDER BY \(orderby.joined(separator: ",")) \(isasc ? "ASC" : "DESC" )
            """)
        }
        if limmit != nil{
            sql.append("""
            
            LIMIT \(limmit!.length) OFFSET \(limmit!.location*limmit!.length)
            """)
        }
        log(sql)
        guard let datas = try db?.prepare(sql).to_dict() else {
            return []
        }
        return datas
    }
}
