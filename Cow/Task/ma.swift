//
//  Singn.swift
//  Cow
//
//  Created by admin on 2021/8/20.
//

import Foundation
import Magicbox
// 计算并保存均值（5，10，20，30，60）
let ma_s = [5,10,20,30,60]
func task_ma_save(code:String,type:Int) throws {
    var table:String?
    switch type {
    case 0:
        table = "StockDaily"
    default:
        break
    }
    guard let ntable = table else {
        throw BaseError(code: -1, msg: "表不存在")
    }
    let datas = try sm.select(table: ntable,  isasc: true)
    let close = datas.enumerated().map { (index,item) in
        item["close"].double()
    }
    var mas = [Any]()
    for item in ma_s {
        mas.append(lib_ma(item, closes: close))
    }
  
    
}
