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
	@IBOutlet weak var totalAssetsLab: UILabel! // 持仓成本
    
	@IBOutlet weak var earningsLab: UILabel!
	@IBOutlet weak var storeMoneyLab: UILabel! // 持仓收益
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
		cutdown = 10
		
	}
	// 获取持仓收益
	func gettotalAssets(){
		
        let datas = StockManage.share.datas
        
        let stores  = datas.filter { $0["sprice"].double()<=0}
        let finesh  = datas.filter { $0["sprice"].double()>0}
        // 持仓收益
        storeMoneyLab.text = Transaction.soreEarnings(stores).string()
        // 持仓成本
        totalAssetsLab.text = Transaction.soreCost(stores).price()
        // 卖出总收益
        earningsLab.text = Transaction.finishEarnings(finesh).price()
        // 手续费
        freelab.text = datas.reduce(0.0, { a, b in
            a+b["bfree"].double()+b["sfree"].double()
        }).price()
		
	}
	deinit{
		NotificationCenter.default.removeObserver(self, name: Global.globleNotification, object: nil)
	}

}
