//
//  Signal.swift
//  apple
//
//  Created by admin on 2021/7/9.
//

import Foundation
import Magicbox

// 方案
class Scheme{
    
    var name:String = "方案名称"
    
    private var _signal:Float = 0.98{
        didSet{
            cachedata = nil
        }
    }
    
    var signal:Float{
        set{
            if _signal == newValue{
                return
            }else{
                _signal = newValue
            }
        }
        get{
            return _signal
        }
    }
    
    var date:String = Date().toString("yyyyMMdd")
    
    var cachedata:[[String:Any]]? = nil
    
    var datas:[[String:Any]] = []
    
    var cellheight:CGFloat = 120.0
    
    // 计算信号量
    func signal(index:Int) -> Float{return 0}
    
    // 交易
    func transaction(index:Int) -> Any?{ return nil}
    
    // 获取今日推荐
    func recommend(_ data:String? = nil ,didchange:@escaping ([[String:Any]])->()) { }
  
    
    // 参数描述
    var param:String{
        return "\(signal)"
    }
    
    // 数据存储表
    var tableName:String?{
//        irogi_etf_signal_\(speed)
        return nil
    }
    func setting()  {
      
    }
}










