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
class Kirogi:SchemeProtocol{
    override init() {
        super.init()
        // 检查配置文件是否创建
        setup()
    }
 
  
    var date = Date()
    var ma1 = 5
    var ma2 = 30
    
    // 计算信号量
    override func signal(index:Int) -> Float{
        let data = datas[index]
        if data["ma5"].double() > data["ma30"].double(){
            return 1
        }else{
            return 0
        }
    }
    
    override func transaction(index: Int) -> Any {
        return 1
    }
    
    
    // 获取今日推荐
    override func recommend(_ data:String)throws -> [[String:Any]] {
     
        let datas = try sm.select_follow_stockbasic_stockma(fitter:
                                                                "t3.date='\(data)' and t3.ma\(ma1)>=t3.ma\(ma2)"
        )
        
       return datas
       
        
    }
    
}
extension Kirogi{
    func setup()  {
        let configpath:String = "\(KDocumnetPath)/Cerebro"
        let manager = FileManager.default
        let exist = manager.fileExists(atPath: configpath)
        if !exist {
            try! manager.createDirectory(at: URL(fileURLWithPath: configpath), withIntermediateDirectories: true,
                                         attributes: nil)
            let plistpath = "\(configpath)/Kirogi.plist"
            let defualdata:NSDictionary = [
                "ma1":5,
                "ma2":30,
            ]
            
            defualdata.write(toFile: plistpath, atomically: true)
        }
    }
}
