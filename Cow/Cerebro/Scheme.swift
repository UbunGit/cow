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
    
    
    // 获取今日推荐
    func recommend(didchange:@escaping ([[String:Any]])->()) { }
  
    
    // 参数描述
    var param:String{
        return "\(signal)"
    }
    
    // 服务器信号量表数据存储表
    var tableName:String?{
        return nil
    }
    func setting()  {
      
    }
}










