//
//  Kirogi.swift
//  apple
//  Kirogi 鸿雁 朝鲜 一种候鸟
//  Created by admin on 2021/7/9.
//

/**
 均线选股 当ma1>ma2时标记为买入
 */
import Foundation
import Magicbox
import Alamofire
class Kirogi:Scheme{

    
    var type:String = "etf"
    
    private var _speed:Int = 5{
        didSet{
            cachedata = nil
        }
    }
    var speed:Int{
        set{
            if _speed == newValue{
                return
            }else{
                _speed = newValue
            }
        }
        get{
            return _speed
        }
    }
    
    

    override init() {
        super.init()
        self.name = "Kirogi"
        if UserDefaults.standard.float(forKey: "kirogi.signal")>0 {
            self.signal = UserDefaults.standard.float(forKey: "kirogi.signal")
            
        }
        if UserDefaults.standard.float(forKey: "kirogi.speed")>0 {
            self.speed = UserDefaults.standard.integer(forKey: "kirogi.speed")
        }
      
        
    
    }
    
    override var param:String{
        return "天数\(speed)/信号量\(signal)"
    }
    // 数据存储表
    override var tableName:String?{
        
        return "kirogi_etf_signal_\(speed)"
    }
    
    override func setting()  {
        let setvc = KirogiSettingVC()
        setvc.kirogi = self
        KWindow??.rootViewController?.present(setvc, animated: true, completion: nil)
    }
 

    override func recommend(_ data:String? = nil ,didchange:@escaping ([[String:Any]])->()) {
        
        if let cadata = cachedata {
            didchange(cadata)
            return
        }
        let url = "\(baseurl)/select"
     
        let param = ["sql":"""
            select t1.code,t1.sort,t1.count,t1.signal, t2.name
            from kirogi_\(type)_signal_\(speed) as t1
            LEFT JOIN \(type)basic as t2
            ON t1.code = t2.code
            LEFT JOIN \(type)daily as t3 ON t1.code=t3.code and t3.date='\(date)'
            where t1.date='\(date)' and t1.signal>=\(signal) and t3.vol>100000000
            ORDER BY t1.signal  DESC
            """]
        
        AF.request(url, method: .post, parameters: param,encoder:JSONParameterEncoder.default)
            .responseModel([[String:Any]].self) { result in
                switch result{
                case .success(let value):
                    self.cachedata = value
                    didchange(value)
                case .failure(_):
                    break
                }
            }
    }

    
}

