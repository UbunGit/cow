//
//  Transaction.swift
//  Cow
//
//  Created by admin on 2022/1/14.
//

import Foundation
class Transaction:NSObject{
    
    static func datas(_ code:String) ->[[String:Any]]{
        StockManage.share.datas.filter { $0["code"].string() == code }
    }
    
    static func soreDatas(_ code:String) ->[[String:Any]] {
        let datas = Self.datas(code)
        return datas.filter{ $0["sprice"].double() <= 0 }
    }
    
    static func finishDatas(_ code:String) ->[[String:Any]] {
        let datas = Self.datas(code)
        return datas.filter{ $0["sprice"].double() > 0 }
    }
    // 单条数据收益金额
    static func earnings(_ data:[String:Any]) -> Double{
        let bprice = data["bprice"].double()
        let price = data["price"].double()
        let bcount = data["bcount"].double()
        let bfree = data["bfree"].double()
        return ((price-bprice)*bcount)-bfree
    }
    // 单条数据收益率（不减手续费）
    static func yield(_ data:[String:Any]) -> Double{
        let bprice = data["bprice"].double()
        let price = data["price"].double()
        let sprice = data["sprice"].double()
        if sprice>0{
            return (sprice/bprice)-1
        }else{
            return (price/bprice)-1
        }
   
       
    }
    
    
    static func max(_ datas:[[String:Any]]) -> [String:Any]?{
        datas.max{ $0["bprice"].double()<$1["bprice"].double()}
    }
    static func min(_ datas:[[String:Any]]) -> [String:Any]?{
        datas.min{ $0["bprice"].double()<$1["bprice"].double()}
    }
    
    // 获取持股总数
    static func soreCount(_ datas:[[String:Any]])->Int{
        
        datas.reduce(0) { a, b in
            a+b["bcount"].int()
        }
    }
    
    // 获取总成本
    static func soreCost(_ datas:[[String:Any]])->Double{
        
        datas.reduce(0) { a, b in
            a+(b["bcount"].double()*b["bprice"].double())
        }
    }
    
    // 获取持仓总收益
    static func soreEarnings(_ datas:[[String:Any]])->Double{
        
        datas.reduce(0) { a, b in
            let bprice = b["bprice"].double()
            let price = b["price"].double()
            let bcount = b["bcount"].double()
            let earn = (price-bprice)*bcount
            return a+earn
        }
    }
    
    // 获取已卖出总收益
    static func finishEarnings(_ datas:[[String:Any]])->Double{
        
        datas.reduce(0) { a, b in
            let bprice = b["bprice"].double()
            let price = b["sprice"].double()
            let bcount = b["bcount"].double()
            let bfree = b["bfree"].double()
            let sfree = b["sfree"].double()
            let free = bfree + sfree
            let earn = ((price-bprice)*bcount) - free
            return a+earn
        }
    }
    
    // 获取持仓总资产
    static func soreAssets(_ datas:[[String:Any]])->Double{
        
        datas.reduce(0) { a, b in
       
            let price = b["price"].double()
            let bcount = b["bcount"].double()
            let asset = price*bcount
            return a+asset
        }
    }
}




