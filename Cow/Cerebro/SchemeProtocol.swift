//
//  Signal.swift
//  apple
//
//  Created by admin on 2021/7/9.
//

import Foundation


// 方案
class SchemeProtocol{
    

    var datas:[[String:Any]] = []
    
    // 计算信号量
    func signal(index:Int) -> Float{return 0}
    
    // 交易
    func transaction(index:Int) -> Any?{ return nil}
    
    // 获取今日推荐
    func recommend(_ data:String? = nil)throws -> [[String:Any]] {return [] }
}










