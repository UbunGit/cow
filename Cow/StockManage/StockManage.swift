//
//  StoreManage.swift
//  Cow
//
//  Created by admin on 2022/1/12.
//

import Foundation
import Alamofire

class StockManage:NSObject{
	
	static let `share` = StockManage()
	var cutdown = 0
    var datas:[[String:Any]]{
        let userid:String = Global.share.user?.userId.string() ?? "0"
        let sql = """
        select t1.*,t2.price,t3.name from rel_transaction  t1
        left join stock_price t2 on t1.code=t2.code
        left join stock_basic t3 on t1.code=t3.code
        where t1.userid=\(userid)
        """
        return sm.select(sql)
    }
	
	var codes:[String]{
		let sql = """
  SELECT code from rel_transaction  GROUP BY code
  """
		return sm.select(sql).map { $0["code"].string()}
	}
	
	private override init(){
		super.init()
		NotificationCenter.default.addObserver(self, selector: #selector(self.globlaTimerDoit), name: Global.globleNotification, object: nil)
	}
	@objc func globlaTimerDoit(){
		
		
		if cutdown%20==0{
			reloadPrice()
		}
		if cutdown%60==0{
			reloadStoreData()
		}
		if cutdown<=0{
			cutdown = 60*60
			return
		}
		cutdown-=1
		
	}
}
// 更新交易数据
extension StockManage{
    // 重新加载数据
    public func reloadStoreData(){
        AF.af_select(" select * from rel_transaction "){ [weak self] result in
            switch result{
            case .success(let value):
                
                self?.cacheStoreData(value)
            case .failure(let err):
                self?.log(err.msg)
            }
        }
    }
    // 缓存交易数据
    func cacheStoreData(_ data:[[String:Any]]){
  
        guard let firstdata = data.first
        else{
            return
        }
        let keys = firstdata.keys.map { $0 }
        let _  = sm.mutableinster(table: "rel_transaction", column: keys, datas: data)
    }
}

// 更新股票价格
extension StockManage{
	
    func price(_ code:String)->Double{
        let sql = " select price from stock_price where code='\(code)'"
        if let data = sm.select(sql).first{
            return data["price"].double()
        }else{
            return 0
        }
        
    }
	func reloadPrice(){
 
		let tcodes = codes.map { item -> String in
			let arr = item.split(separator: ".")
			var code = item
			if arr.count == 2 {
				code =  String(arr[1]+arr[0])
			}
			return code.lowercased()
		}
		//
      
		let url = "http://hq.sinajs.cn/list=\(tcodes.joined(separator: ","))"

		let headers: HTTPHeaders = [
			"Referer": "https://finance.sina.com.cn/"
		]
		AF.request(url,headers: headers)

			.responseString { [weak self] result in
				guard let datastr = result.value else{
					return
				}
				let datas = datastr.split(separator: ";")
				var results:[[String:Any]] = []
				datas.enumerated().forEach{ (index,item) in
					let prices = item.split(separator: ",")
					guard prices.count > 3,
					   let code = self?.codes[index]
					else{
						return
					}
					results.append([
						"code":code,
						"price":prices[3]
					])
				}
				self?.cachePrice(results)
			}
	}
	
	func cachePrice(_ value:[[String:Any]]){
		let _ = sm.mutableinster(table: "stock_price", column: ["code","price"], datas: value)
	}
}

// 更新股票名称
extension StockManage{
	func cacheStoreName(_ code:String, name:String){
		let param = [
			"code":code,
			"name":name
		]
		let _ = sm.mutableinster(table: "stock_basic", column: ["code","name"], datas: [param])
	}
	func storeName(_ code:String)->String{
		// 从本地数据库获取
		let sql = """
		select name from stock_basic where code='\(code)'
		"""
		if let data = sm.select(sql).first{
			return data["name"].string()
		}
		
		// 从服务器获取
		let ssql = """
		SELECT code, name FROM (
		SELECT code,name FROM etfbasic
		UNION
		SELECT code, name FROM stockbasic)
		WHERE code='\(code)'
		"""
		AF.af_select(ssql) {[weak self] result in
			switch result{
			case .success(let value):
				if let data = value.first,
				let name = data["name"] as? String
				{
					self?.cacheStoreName(code, name: name)
				}
			case .failure(let err):
                self?.log(err.msg)
			}
		}
        return "获取中"

	}
}

