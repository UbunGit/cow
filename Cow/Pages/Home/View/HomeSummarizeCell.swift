//
//  HomeSummarizeCell.swift
//  Cow
//
//  Created by admin on 2022/1/8.
//

import UIKit




class HomeSummarizeCell: UICollectionViewCell {
	var cutdown = 0
	@IBOutlet weak var freelab: UILabel!
	@IBOutlet weak var totalAssetsLab: UILabel!
    
	@IBOutlet weak var earningsLab: UILabel!
	@IBOutlet weak var storeMoneyLab: UILabel!
	override func awakeFromNib() {
        super.awakeFromNib()
		NotificationCenter.default.addObserver(self, selector: #selector(globlaTimerDoit), name: Global.globleNotification, object: nil)
      
    }
	@objc func globlaTimerDoit(){
		if cutdown>0{
			cutdown-=1
			return
		}
		gettotalAssets()
		cutdown = 20
		
	}
	// 获取持仓收益
	func gettotalAssets(){
		let sql = """
	select t1.*,t2.price from rel_transaction t1
	left join stock_price t2 on t2.code=t1.code
	where t1.userid=\(Global.share.userId)
	"""
		let datas = sm.select(sql)
		var sum:Double = 0
		var amount:Double = 0
		var ear:Double=0
		var free:Double=0
		datas.forEach { item in
			let bcount = item["bcount"].int()
			let price = item["price"].double()
			let bprice = item["bprice"].double()
			let sprice = item["sprice"].double()
			let bfree = item["bfree"].double()
			let sfree = item["sfree"].double()
			let sdate = item["sdate"].string()
			
			if sdate == ""{
				let am = bprice*bcount.double()
				let value = (price-bprice)*bcount.double()
				sum += value
				amount += am
			}else{
				let val = (sprice-bprice)*bcount.double() - (bfree+sfree)
				ear += val
			}
			free+=(bfree+sfree)
			
		}
		storeMoneyLab.text = sum.price()
		totalAssetsLab.text = amount.price()
		earningsLab.text = ear.price()
		freelab.text = free.price()
		
	}
	deinit{
		NotificationCenter.default.removeObserver(self, name: Global.globleNotification, object: nil)
	}

}
