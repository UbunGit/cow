//
//  APIScheme.swift
//  Cow
//
//  Created by admin on 2021/11/4.
//

import Foundation
import Alamofire

extension Session {
    /** :
     获取策略模版列表
     out:
     id: id
     name: 策略名称
     des: 描述
     */
    func scheme_template_list() -> DataRequest{
        let sql = """
        select * from scheme_template
        """
        return AF.select(sql)
    }
    
    /**
     获取模版参数
     */
    func scheme_template_param_list(_ id:Int) -> DataRequest{
        let sql = """
            select * from scheme_template_param where template_id =\(id)
            """
        return AF.select(sql)
    }
    
    /**
     获取策略列表
     */
    func scheme_list() -> DataRequest{
        let sql = """
            select * from scheme
            """
        return AF.select(sql)
    }
    
    /**
     获取策略推荐股票
     */
    func scheme_rec(id:Int,date:String) -> DataRequest{
        let url = "\(baseurl)/scheme/rec"
        let param = [
            "id":id.string(),
            "date":date
        ]
        return self.request(url, method: .post,
                            parameters: param,
                            encoder: JSONParameterEncoder.default,
                            requestModifier: { urlRequest in
            urlRequest.timeoutInterval = 15
        })
    }
    
    /**
     获取策略选股池
     */
    func scheme_pool(_ id:Int) -> DataRequest{
        let sql = """
        select t1.id,type,t1.code,t2.name from scheme_codes t1
        LEFT JOIN
        (
        SELECT code,name FROM etfbasic
        UNION
        SELECT code, name FROM stockbasic
        ) t2 ON t2.code=t1.code
        WHERE t1.scheme_id =\(id)
        """
        return AF.select(sql)
    }
    
    /**
     获取策略选股池
     */
    func code_info(_ codes:[String]) -> DataRequest{
        let sql = """
        select * from
        (
        SELECT code,name FROM etfbasic
        UNION
        SELECT code, name FROM stockbasic
        ) t
        WHERE t.code in (\(codes.map{ "'\($0)'" }.joined(separator: ",")))
        """
        return AF.select(sql)
    }
    /**
     获取股票数据
     */
    func dailydata(_ code:String,type:Int,begin:String?=nil,end:String?=nil) -> DataRequest{
        var sql = ""
        if type == 0{
            sql = " SELECT * FROM etfdaily "
        }else if type == 1{
            sql = " SELECT * FROM stockdaily "
        }
        var wherestr = " where code='\(code)' "
        if let be = begin,
        let en = end
        {
            wherestr.append(" AND date BETWEEN '\(be)' AND '\(en)' ")
           
        }else if let be = begin{
            wherestr.append(" AND date>'\(be)' ")
        }else if let en = end{
            wherestr.append(" AND date<'\(en)' ")
        }
        return AF.select(sql)
    }
    
}


