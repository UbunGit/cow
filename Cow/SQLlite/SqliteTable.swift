//
//  SqliteTable.swift
//  Cow
//
//  Created by admin on 2021/8/17.
//

import Foundation
import HandyJSON
import Magicbox

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
    public  func droptable( tablename:String) throws {
        guard let tdb = db else {
            throw BaseError(code: -2, msg: "db 初始化错误")
        }
        let exeStr = "drop table if exists \(tablename) "
        try tdb.execute(exeStr)
        
    }
    
}
