//
//  stockbasic+.swift
//  Cow
//
//  Created by admin on 2021/8/23.
//

import Foundation

extension SqlliteManage{
    func select_stockbasic_follow( fitter:String = "",
                           orderby:[String] = [],
                           limmit:NSRange? = nil,
                           isasc:Bool = true)throws -> [[String:Any]] {
        
        var sql = """
                SELECT t1.id, t2.code, t2.name
                FROM  follow t1
                LEFT JOIN stockbasic t2 ON t1.pid=t2.code
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
            
            LIMIT \(limmit!.length) OFFSET \(limmit!.location)
            """)
        }
        print(sql)
        guard let datas = try db?.prepare(sql).to_dict() else {
            return []
        }
        return datas
        
        
    }
    
}
