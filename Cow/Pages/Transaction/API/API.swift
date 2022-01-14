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
     state -1 全部 0 ->未卖出 1 ->已卖出
     */
    func api_reltransaction(_ state:Int? = -1) ->  [[String:Any]]{
        var whereStr = " userid=\(Global.share.user!.userId) "
        if state == 0{
            whereStr.append(" AND sdate='' ")
        }else if state == 1{
            whereStr.append(" AND sdate is not '' ")
        }
        let sql = """
            SELECT t1.code,t2.name
            FROM (SELECT code from rel_transaction where \(whereStr) GROUP BY code ) t1
            
            LEFT JOIN (select code, name from stock_basic) t2 ON t1.code=t2.code
            """
		return sm.select(sql)
    }
	
	func api_reltransaction(_ state:Int? = -1, code:String) -> [[String:Any]]{
		var whereStr = " t1.userid=\(Global.share.user!.userId) and t1.code='\(code)' "
		if state == 0{
			whereStr.append(" AND sdate='' ")
		}else if state == 1{
			whereStr.append(" AND sdate is not '' ")
		}
		let sql = """
		select t1.*,t2.price,t3.name from rel_transaction  t1
		left join stock_price t2 on t1.code=t2.code
		left join stock_basic t3 on t1.code=t3.code
		where \(whereStr)
		
		"""
		return sm.select(sql)
	}
	
	func api_reltransactioninfo(_ state:Int? = -1, code:String) -> Transaction{
		var info = Transaction()
		let  datas = api_reltransaction(state,code: code)
		info.datas = datas
		if let first = datas.first{
			info.code = first["code"].string()
			info.name = first["name"].string()
		}
		
	
		var sum:Double = 0 // 持仓总收益
		var amount:Double = 0 // 总成本
		var ear:Double=0 // 实现总收益
		var allcount:Int=0 // 总持仓股数
		var free:Double=0 // 总手续费
	
		datas.forEach { item in
			let bcount = item["bcount"].int()
			let price = item["price"].double()
			let bprice = item["bprice"].double()
			let sprice = item["sprice"].double()
			let bfree = item["bfree"].double()
			let sfree = item["sfree"].double()
			let am = bprice*bcount.double()
			let value = (price-bprice)*bcount.double()
			let val = (sprice-bprice)*bcount.double() - (bfree+sfree)
			sum += value
			amount += am
			allcount += bcount
			ear += val
			free+=(bfree+sfree)
			
		}
		info.storeCount = allcount
//		info["datas"] = datas
//		info["sum"] = sum
//		info["amount"] = sum
//		info["ear"] = ear
//		info["allcount"] = allcount
//		info["free"] = free
		return info
		
	}
}
