//
//  etfbasic+.swift
//  Cow
//
//  Created by admin on 2021/8/23.
//

import Foundation

extension SqlliteManage{
    // 获取股票列表 有关注 状态
    func select_etfbasic_follow(
        orderby:[String] = ["t2.follow","t1.name"],
        limmit:NSRange = NSRange(location: 0, length: 10),
        asc:Bool = true
    ) -> String{
        var t2 = "etffollow"
        if let userid = Global.share.user?.userId{
            t2 = " (select * from etffollow e where e.userId=\(userid)) "
        }
        let sql = """
                SELECT t1.name,t1.code,
                t2.status,t2.follow,t2.id
                FROM  etfbasic t1
                LEFT JOIN \(t2) t2 ON t1.code=t2.code
                ORDER BY \(orderby.joined(separator: ",")) \(asc ? "ASC" : "DESC" )
                LIMIT \(limmit.length) OFFSET \(limmit.location*limmit.length)
                """
        return sql
    }
    
    func select_follow_etfbasic( fitter:String = "",
                           orderby:[String] = [],
                           limmit:NSRange = NSRange(location: 0, length: 10),
                           isasc:Bool = true) ->String {
        
        var sql = """
                SELECT t1.status,t1.follow,t1.id,
                t2.name,t2.code
                FROM  etffollow t1
                LEFT JOIN etfbasic t2 ON t1.code=t2.code
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
            
        LIMIT \(limmit.length) OFFSET \(limmit.location*limmit.length)
        """)
       
        return sql
    }
    
    func insteretffollow(code:String,userId:Int) -> String {
        """
            INSERT INTO "etffollow" (code,userId,follow,status)
            values ('\(code)',\(userId),1,0);
            """
    }
    
}
