//
//  Task.swift
//  Cow
//
//  Created by admin on 2021/8/16.
//

import Foundation
import UIKit
import Magicbox
import Alamofire
import HandyJSON

struct Task {
    var name:String
    var handle:(_ group:DispatchGroup) throws ->()
}

extension Task{
    // 创建表
    static func  task_createTable() {
      
        UIView.loading()
        
        let queue = DispatchQueue(label: "task.createTable.Queue")
        let group = DispatchGroup()
        queue.async {
            do {
                
                for task in try sm.checkupTable() {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue:"msg"), object: task.name,userInfo:nil)
                    group.enter()
                    try task.handle(group)
                }
                group.notify(queue: DispatchQueue.main) {
                    UIView.loadingDismiss()
                    UIView.success("table 创建检查完成")
                }
            } catch let error {
                print(error.localizedDescription)
                UIView.loadingDismiss()
                UIView.error(error.localizedDescription)
            }
            
        }
        
    }
}
// 股票数据
extension Task{
    
    // 下载股票数据
    static func task_updateSoredata() throws{
        UIView.loading()
        let result = try getFollowModels(type: 1)
        let tasks:[Task] = result.map({ item in
            .init(name: "更新关注股票日线数据\(item.code)", handle: { group in
               
                NotificationCenter.default.post(name: NSNotification.Name(rawValue:"msg"), object: "更新关注股票日线数据\(item.code)",userInfo:nil)
                let sema = DispatchSemaphore(value: 0)
                let url = baseurl+"/share/daily"
                let params = ["code":item.code]
             
                var af_error:APIError? = nil
                var datas:[[String:Any]]  = []
                
                AF.request(url, method: .get, parameters: params)
                    .responseModel([[String:Any]].self) { result  in
                    switch result{
                    case .success(let value):
                        datas = value
                        
                    case .failure(let error):
                        af_error = error
                    }
                    sema.signal()
                    
                }
                sema.wait()
                if af_error != nil{
                    throw af_error!
                }
                try sm.mutableinster(table: "stockdaily", column: ["date","code","open","close","high","low","amount","vol"], datas: datas)
                
                group.leave()
                
            })
        })
        
        let queue = DispatchQueue(label: "task.createTable.Queue")
        let group = DispatchGroup()
        queue.async {
            do {
                
                for task in tasks {
                    
                    group.enter()
                    try task.handle(group)
                }
                group.notify(queue: DispatchQueue.main) {
                    UIView.loadingDismiss()
                    UIView.success("下载股票数据成功")
                }
            } catch let error {
                print(error.localizedDescription)
                UIView.loadingDismiss()
                UIView.error(error.localizedDescription)
            }
            
        }
    }
    
    
    static func getFollowModels(type:Int)  throws ->[FollowModel] {
        do {
            let sql = """
                SELECT t1.id, t2.code, t2.name
                FROM  follow t1
                LEFT JOIN stockbasic t2 ON t1.pid=t2.code
                WHERE t1.type = 1
                """
            
            guard let stmt = try sm.db?.prepare(sql) else {
                throw(BaseError(code: -2, msg: ""))
            }
            return  stmt.to_moden(FollowModel.self)
        } catch  {
            print(error.localizedDescription)
        }
        return []
        
    }
  
}
