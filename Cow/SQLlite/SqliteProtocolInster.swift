//
//  SqliteProtocolInster.swift
//  Cow
//
//  Created by admin on 2021/8/9.
//

import Foundation
import SQLite
import Magicbox

public enum CRUDInsertModel:String {
    case None = "" // 直接插入
    case Replace = "OR REPLACE" // 替换
    case Ignore = "OR IGNORE" // 忽略
}

extension SqliteProtocol{
    
 
    
    static func mutableinster(datas:[Self], model:CRUDInsertModel = .Replace) throws -> Int  {
        if datas.count <= 0 {
            throw BaseError(code: -1, msg: "插入数据为空")
        }
        guard Self().table != nil else {
            throw BaseError(code: -1, msg: "创建表失败")
           
        }
        
        let mirror = Mirror(reflecting:Self.init())
        let atts = mirror.children.map { child -> String in
            print("\(child.label!)---\(child.value)")
            return child.label!
        }.joined(separator: ",")
        var sql = "INSERT \(model.rawValue) INTO \(Self.tableName) (\(atts)) VALUES "
        
        let values = datas.map { item in
            
            let tmirror = Mirror(reflecting:item)
            let value = tmirror.children.map { child in
                 "'\(child.value)'"
            }.joined(separator: ",")
            return "(\(value))"
        }.joined(separator: ",")
        sql.append(values)
        print(sql)
        try db?.execute(sql)
//        db.totalChanges    // 3
//        db.changes         // 1
//        db.lastInsertRowid // 3
        return db?.totalChanges ?? 0
    }
    
  
    
}

