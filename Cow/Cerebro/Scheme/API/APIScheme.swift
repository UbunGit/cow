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
            sql = " SELECT * FROM stockdaily "
        }else if type == 1{
            sql = " SELECT * FROM etfdaily "
            
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
        sql.append(wherestr)
        return AF.select(sql)
    }
    
    // 获取策略交易列表
    func back_trade(schemeId:Int)-> DataRequest{
        let sql = " select * FROM back_trade where scheme_id = '\(schemeId)' "
        return AF.select(sql)
    }
    // 给策略添加股票
    func scheme_addCode(_ scheme_id:Int, item:[String:Any]) -> DataRequest{
        let url = "\(baseurl)/scheme/update"
        let sql = """
        INSERT INTO scheme_codes
        (code,type,scheme_id) VALUES
        ('\(item["code"].string())','\(item["type"].string())','\(scheme_id)')
        """
        let param = [
            "id":"\(scheme_id)",
            "sql":sql
        ]
        print("🐶："+sql)
        return self.request(url, method: .post,
                            parameters: param,
                            encoder: JSONParameterEncoder.default,
                            requestModifier: { urlRequest in
            urlRequest.timeoutInterval = 15
        }
        )
    }
    // 删除股票池股票
    func scheme_deleteCode(_ scheme_id:Int, codeId:Int) -> DataRequest{
        let url = "\(baseurl)/scheme/update"
        let sql = """
        DELETE FROM scheme_codes
        WHERE id=\(codeId) and scheme_id=\(scheme_id)
        """
        let param = [
            "id":"\(scheme_id)",
            "sql":sql
        ]
        print("🐶："+sql)
        return self.request(url, method: .post,
                            parameters: param,
                            encoder: JSONParameterEncoder.default,
                            requestModifier: { urlRequest in
            urlRequest.timeoutInterval = 15
        }
        )
    }
    // 回测
    func scheme_exit(_ scheme_id:Int) -> DataRequest{
        let url = "\(baseurl)/scheme/exit"
      
        let param = [
            "id":"\(scheme_id)",
        ]
 
        return self.request(url, method: .post,
                            parameters: param,
                            encoder: JSONParameterEncoder.default,
                            requestModifier: { urlRequest in
            urlRequest.timeoutInterval = 15
        }
        )
    }
    
    // 获取最后一个交易日
    func scheme_lastDate(_ scheme_id:Int)-> DataRequest{
       let sql = """
        select max(date) date from
                (
                SELECT date,code FROM etfdaily
                UNION
                SELECT date,code FROM stockdaily
                ) t
        WHERE t.code in (
        SELECT code FROM scheme_codes WHERE scheme_id =\(scheme_id)
        )
        """
        return AF.select(sql)
    }
    
}


