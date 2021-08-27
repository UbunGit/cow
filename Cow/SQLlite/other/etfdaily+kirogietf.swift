//
//  etfdaily.swift
//  Cow
//
//  Created by admin on 2021/8/27.
//

import Foundation
import Foundation
import Alamofire

extension SqlliteManage{
    
    func select_etfdaily_kirogetf(fitter: String, orderby: [String], limmit:NSRange = NSRange(location: 0, length: 100), isasc:Bool = false,finesh:@escaping (Result<[[String:Any]], Error>)  ->  ()) {
        var sql = """
            SELECT t1.*,t2.speed5,
            t2.speed10, t2.speed20,t2.speed30,t2.speed60,
            t3.ma5,t3.ma10,t3.ma20,t3.ma30,t3.ma60
            from etfdaily as t1
            LEFT JOIN kirogietf as t2
            ON t1.code = t2.code AND t1.date = t2.date
            LEFT JOIN damreyetf as t3
            ON t1.code = t3.code AND t1.date = t3.date
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
        
        sql.append("""
            
            LIMIT \(limmit.length) OFFSET \(limmit.location)
            """)
      
        
        AF.af_select(sql, callback: finesh)
    }
}
