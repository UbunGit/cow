//
//  File.swift
//  Cow
//
//  Created by mac on 2022/7/8.
//

import Foundation

class TransactionItem:NSObject,Codable{
    
    var id = 0
    var userid = 0
    var code = ""
    var type = 1 // 股票类型 1->股票 2->ETF
    var bdate:String? // 买入时间
    var bprice = 0.0 // 买入价格
    var bcount = 0 //买入数量
    var bfree = 0.0 // 买入手续费
    var sdate:String? // 卖出时间
    var sprice = 0.0 // 卖出价格
    var sfree = 0.0 // 卖出手续费
    var target = 0.0 // 目标价格
    var plan = "" // 策略
    var remarks = "" // 备注
    var price = 0.00

    // get
    var typeStr:String{
        switch type {
        case 1:
            return "股票"
        case 2:
            return "ETF"
        default:
            return "选择股票类型"
        }
    }
    
    // 单条数据收益金额
    var earnings:Double{

        let bprice = bprice
        let price = price
        let bcount = bcount.double()
        let bfree = bfree
        let sprice = sprice
        let sfree = sprice
        if sprice>0{
            return ((sprice-bprice)*bcount)-bfree-sfree
        }else{
            return ((price-bprice)*bcount)-bfree
        }
    }
    // 单条数据收益率（不减手续费）
    var yield: Double{
        let bprice = bprice
        let price = price
        let sprice = sprice
        if sprice>0{
            return (sprice/bprice)-1
        }else{
            return (price/bprice)-1
        }
    }
}

class Transaction:NSObject,Codable{
  
    
    static func items(code:String)->[TransactionItem]{
        let datas = StockManage.share.datas.filter { $0["code"].string() == code }
        return [TransactionItem].array(any: datas)
    }
    
    static func datas(_ code:String) ->[[String:Any]]{
        StockManage.share.datas.filter { $0["code"].string() == code }
    }
    
    static func soreDatas(_ code:String) ->[TransactionItem] {
        let datas = Self.items(code: code)
        return datas.filter{ $0.sprice.double() <= 0 }
    }
    
    static func finishDatas(_ code:String) ->[TransactionItem] {
        let datas = Self.items(code: code)
        return datas.filter{ $0.sprice.double() > 0 }
    }
    // 单条数据收益金额 废弃
    static func earnings(_ data:[String:Any]) -> Double{
    
        
        let bprice = data["bprice"].double()
        let price = data["price"].double()
        let bcount = data["bcount"].double()
        let bfree = data["bfree"].double()
        let sprice = data["sprice"].double()
        let sfree = data["sprice"].double()
        if sprice>0{
            return ((sprice-bprice)*bcount)-bfree-sfree
        }else{
            return ((price-bprice)*bcount)-bfree
        }
    }
    // 单条数据收益率（不减手续费） 废弃
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
    
    
    static func max(_ datas:[TransactionItem]) -> TransactionItem?{
        datas.max{ $0.bprice<$1.bprice}
    }
    static func min(_ datas:[TransactionItem]) -> TransactionItem?{
        datas.min{ $0.bprice<$1.bprice}
    }

    // 获取持股总数
    static func soreCount(_ datas:[TransactionItem])->Int{
        
        datas.reduce(0) { a, b in
            a+b.bcount
        }
    }
    
    // 获取总成本
    static func soreCost(_ datas:[TransactionItem])->Double{
        
        datas.reduce(0) { a, b in
            a+(b.bcount.double()*b.bprice.double())
        }
    }
    
    // 获取持仓总收益
    static func soreEarnings(_ datas:[TransactionItem])->Double{
        
        datas.reduce(0) { a, b in
            let bprice = b.bprice
            let price = b.price
            let bcount = b.bcount.double()
            let earn = (price-bprice)*bcount
            return a+earn
        }
    }
    
    // 获取已卖出总收益
    static func finishEarnings(_ datas:[TransactionItem])->Double{
        
        datas.reduce(0) { a, b in
            let bprice = b.bprice
            let price = b.sprice
            let bcount = b.bcount.double()
            let bfree = b.bfree
            let sfree = b.sfree
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


