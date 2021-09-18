//
//  SqliteTable.swift
//  Cow
//
//  Created by admin on 2021/8/17.
//

import Foundation
import HandyJSON
import Magicbox
import Alamofire

extension SqlliteManage{
    
    func tables() throws -> [[String:Any]] {
        let sql = """
            SELECT * FROM sqlite_master
            WHERE type="table"
            """
        guard let datas = try db?.prepare(sql).to_dict() else {
            return []
        }
       
       return datas
    }
    
    /**
     删除表
     */
    public  func dropaftercreatetable( tablename:String) throws {
      
        let sql = "drop table if exists \(tablename) "
        AF.af_update(sql) { result in
            switch result{
            case .success(_):
                UIView.success("表删除成功")
                guard let create = sm.sql_createTable(tablename) else {
                    UIView.success("创建表sql为空")
                    return
                }
                AF.af_update(create) { result in
                    switch result{
                    case .success(_):
                        UIView.success("创建表成功")
                    case .failure(let err):
                        UIView.error(err.localizedDescription)
                    }
                }
            case .failure(let err):
                UIView.error(err.localizedDescription)
            }
        }
        
    }
    
}
