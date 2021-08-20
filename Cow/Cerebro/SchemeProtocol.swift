//
//  Signal.swift
//  apple
//
//  Created by admin on 2021/7/9.
//

import Foundation


// 方案
protocol SchemeProtocol{
    
    associatedtype T:Any

    var datas:[T] { get set }
    
    // 计算信号量
    func signal(index:Int) -> Float
    
    // 交易
    func transaction(index:Int) -> Any
}










