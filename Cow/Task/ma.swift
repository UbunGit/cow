//
//  Singn.swift
//  Cow
//
//  Created by admin on 2021/8/20.
//

import Foundation
import Magicbox
// 计算并保存均值（5，10，20，30，60）
public let KDefualMAS = [5,10,20,30,60]

func task_ma_save(code:String,type:Int = 1) throws {
    var table:String?
    switch type {
    case 1:
        table = "StockDaily"
    default:
        break
    }
    guard let ntable = table else {
        throw BaseError(code: -1, msg: "表不存在")
    }
    let datas = try sm.select(table: ntable,  isasc: true)
    let ma = datas.lib_muma(KDefualMAS, cloume: "close")
 
    try sm.mutableinster(table: "stockma", column: ["code","date","ma5","ma10","ma20","ma30","ma60"], datas: ma)
}
