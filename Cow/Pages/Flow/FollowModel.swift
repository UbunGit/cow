//
//  FollowModel.swift
//  Cow
//
//  Created by admin on 2021/8/11.
//

import Foundation
import SQLite
import HandyJSON
import Magicbox
struct FollowModel:HandyJSON {
    var id:Int = 0
    var type:Int = 0 // 1->股票
    var pid:String = ""
}

extension FollowModel:SqliteProtocol{
    
    init(row: Row) {
        id  = row[Expression<Int>.init("id")]
        type = row[Expression<Int>.init("type")]
        pid = row[Expression<String>.init("pid")]
    }
    var table: Table? {
        do{
            let sql = """
         CREATE TABLE IF NOT EXISTS "\(tableName)"(
            "id" integer AUTO_INCREMENT,
            "type" integer,
            "pid" integer,
            PRIMARY KEY("id")
         )
         """
            try db?.execute(sql)
            return Table(tableName)
        }catch let error {
            debugPrint(error.localizedDescription)
            return nil
        }
    }
    func insert()->Bool {
        
        do{
            guard table != nil else {
                throw BaseError(code: -2, msg: "表未创建")
            }
            let sql = """
         INSERT INTO "\(tableName)" (type,pid) VALUES ('\(type)','\(pid)')
         WHERE NOT EXISTS ( SELECT * FROM "\(tableName)"
                            WHERE type = '\(type)'
                            AND pid = '\(pid)');
         """
            try db?.execute(sql)
            return true
        }catch let error {
            debugPrint(error.localizedDescription)
            return false
        }
    }
   
}
