//
//  Signal.swift
//  apple
//
//  Created by admin on 2021/7/9.
//

import Foundation


// 方案
class SchemeProtocol{
    
    var name:String = "方案名称"
    var signal:Float = 0.98
    
    var date:String = Date().toString("yyyyMMdd")
    
    var datas:[[String:Any]] = []
    
    var cellheight:CGFloat = 120.0
    
    // 计算信号量
    func signal(index:Int) -> Float{return 0}
    
    // 交易
    func transaction(index:Int) -> Any?{ return nil}
    
    // 获取今日推荐
    func recommend(_ data:String? = nil ,didchange:@escaping ([[String:Any]])->()) { }
}










