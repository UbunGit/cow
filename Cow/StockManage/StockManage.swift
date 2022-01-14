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
	var datas:[[String:Any]] = []
	
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
	// 重新加载数据
	public func reloadStoreData(){
		AF.af_select(" select * from rel_transaction "){ [weak self] result in
			switch result{
			case .success(let value):
				self?.datas = value
				self?.cacheStoreData()
			case .failure(let err):
				self?.log(err.msg)
			}
		}
	}
	// 缓存交易数据
	func cacheStoreData(){
		
		let _ = sm.drop("rel_transaction")
		let _ = sm.createTable("rel_transaction")
		guard 	let firstdata = datas.first
		else{
			return
		}
		let keys = firstdata.keys.map { $0 }
		let _  = sm.mutableinster(table: "rel_transaction", column: keys, datas: datas)
	}
}

// 更新股票价格
extension StockManage{
	
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
		AF.request(url)
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
	func storeName(_ code:String, callback:@escaping (_ name:String)->()){
		// 从本地数据库获取
		let sql = """
		select name from stock_basic where code='\(code)'
		"""
		if let data = sm.select(sql).first{
			callback(data["name"].string())
			return
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
					callback(name)
					
				}else{
					callback("--")
				}
			case .failure(let err):
				callback(err.msg)
			}
		}

	}
}

