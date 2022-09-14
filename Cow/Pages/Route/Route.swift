//
//  Route.swift
//  Cow
//
//  Created by admin on 2022/1/13.
//

import Foundation
import UIKit
extension UIViewController{
	// 去持仓列表
	@objc func pushTransaction0(){
		let vc = TransactionListViewController()
        vc.state = .didbuy
		self.navigationController?.pushViewController(vc, animated: true)
	}
	// 去已卖出列表
	@objc func pushTransaction1(){
		let vc = TransactionListViewController()
        vc.state = .didsell
		self.navigationController?.pushViewController(vc, animated: true)
	}
	// 交易详情
    func push_transaction(code:String,state:TradeStatus = .didbuy){
		let vc = TransactionDefVC()
		vc.code = code
		vc.state = state
		self.navigationController?.pushViewController(vc, animated: true)
		
	}
}
