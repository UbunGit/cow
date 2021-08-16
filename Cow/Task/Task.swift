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
        let tasks:[Task] = [
            .init(name: "创建StockBasic表", handle: {group in
                
                let _ =  try sm.create_stockbasic()
                
                group.leave()
            }),
            .init(name: "创建Follow表", handle: { group in
                
                
                let _ = try sm.create_follow()
                group.leave()
            }),
            
        ]
        UIView.loading()
        
        let queue = DispatchQueue(label: "task.createTable.Queue")
        let group = DispatchGroup()
        queue.async {
            do {
                
                for task in tasks {
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
extension Task{
    
    // 下载股票数据
    static func task_updateSoredata()throws{
        UIView.loading()
        try getFollowModels(type: 1) { result in
            
            let tasks:[Task] = result.map({ item in
                .init(name: "更新关注股票日线数据\(item.code)", handle: {group in
                    let _ = try Self.storedaily(code: item.code) {
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue:"msg"), object: "更新关注股票日线数据\(item.code)",userInfo:nil)
                        group.leave()
                    }
                    
                    
                    
                   
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
        
    }
    static func getFollowModels(type:Int,finesh:([FollowModel])->()) throws{
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
            
            stmt.to_moden(FollowModel.self) { result in
                
                finesh(result)
            }
            
        } catch  {
            print(error.localizedDescription)
        }
    }
    static func storedaily(code:String, finesh:@escaping ()->()) throws{
        let url = baseurl+"/share/daily"
        let params = ["code":code]
        
        AF.request(url, method: .get, parameters: params)
            .responseModel([[String:Any]].self) { result in
                switch result{
                case .success(let value):
                    for item in value {
                        print(item)
                    }
                    
                case .failure(let error):
                    print(error.localizedDescription)
                }
                finesh()
            }
    }
}
