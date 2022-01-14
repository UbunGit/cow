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
    func isExistsTable(_ name:String) -> Bool{
        do{
            let sql = """
            SELECT * FROM sqlite_master
            WHERE type="table" and name='\(name)'
            """
            guard let datas = try db?.prepare(sql).to_dict() else {
                return false
            }
            return datas.count==1
        }catch{
            return false
        }
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
    
    func createTable(_ name:String)-> Bool{
        do{
            guard let create = sm.sql_createTable(name) else {
               
                return false
            }
            _ = try db?.execute(create)
            return true
        }catch{
			log("\(error)")
            return false
        }
    }
	
	func drop(_ name:String)->Bool{
		let sql = "drop table if exists \(name) "
		do{
			_ = try db?.execute(sql)
			return true
		}catch{
			self.log(sql)
			return false
		}
	}
    
}
