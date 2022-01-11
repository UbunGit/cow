//
//  API.swift
//  Cow
//
//  Created by admin on 2022/1/8.
//

import Foundation
import Alamofire
extension Session{
    // MARK: 获取真实交易股票列表
    /**
     state 0 ->未卖出 1 ->已卖出
     */
    func api_reltransaction(_ state:Int=0) -> DataRequest{
        var whereStr = " userid=\(Global.share.user!.userId) "
        if state == 0{
            whereStr.append(" AND sdate='' ")
        }else if state == 1{
            whereStr.append(" AND sdate is not '' ")
        }
        let sql = """
            SELECT t1.code,t2.name
            FROM (SELECT code from rel_transaction where \(whereStr) GROUP BY code ) t1
            
            LEFT JOIN (select code, name from stockbasic union all select code,name from etfbasic) t2 ON t1.code=t2.code
            """
        return AF.select(sql)
    }
}
