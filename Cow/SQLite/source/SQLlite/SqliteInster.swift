//
//  SqliteInster.swift
//  Cow
//
//  Created by admin on 2021/8/23.
//

import Foundation
import Magicbox
import SQLite

public extension SqlliteManage{
    /**
     批量插入数据
     */
    func mutableinster(table:String, column:[String],datas:[[String:Any]]) -> Bool  {
        do{
            if try istable(tablename: table) == false {
                throw BaseError(code: -1, msg: "table 未创建")
            }
            
            if datas.count <= 0 {
                throw BaseError(code: -1, msg: "插入数据为空")
            }
            var sql = """
        INSERT OR REPLACE INTO '\(table)' (\(column.map{"'\($0)'"}.joined(separator: ",")))
        VALUES
        """
            
            let val = datas.map { item in
                let tvar = column.map {
                    guard let str = item[$0] else{
                        return "''"
                    }
                    return "'\(str)'"
                    
                }.joined(separator: ",")
                return "(\(tvar))"
            }.joined(separator: ",")
            sql.append(val)
            debugPrint(sql)
            _ = try db?.execute(sql)
            return true
        }catch{
            return false
        }
    }
    
    /**
     批量插入数据
     */
    func mutableinster(table:String, column:String,datas:[Any]) -> Bool  {
        do{
        if try istable(tablename: table) == false {
            throw BaseError(code: -1, msg: "table 未创建")
        }
        
        if datas.count <= 0 {
            throw BaseError(code: -1, msg: "插入数据为空")
        }
        var sql = """
        INSERT OR REPLACE INTO '\(table)' ('\(column)')
        VALUES
        """
        
        let val = datas.map { item -> String in
            return "('\(item)')"
        }.joined(separator: ",")
        sql.append(val)
        print(sql)
        _ = try db?.execute(sql)
            return true
        }catch{
            return false
        }
    }
    
    func sql_update(table:String, data:[String:Any], key:String="id") -> String?{
        var sql = ""
        if  data[key] == nil{
            let xdata = data
            let keys = xdata.keys
            let valueStr = keys.map { "'\(xdata[$0].string())'" }.joined(separator: ",")
            sql = """
            INSERT INTO "\(table)" (\(keys.map{ $0}.joined(separator: ",")))
            values (\(valueStr));
            """
        }else{
            var xdata = data
            xdata.removeValue(forKey: key)
            let keys = xdata.keys
            let updatestr = keys.map{ "\($0)='\(xdata[$0].string())'" }.joined(separator: ",")
   
            sql = """
            UPDATE  "\(table)" SET \(updatestr)
            where \(key)='\(data[key].string())'
            """
        }
        if sql.count>0{
            return sql
        }else{
            return nil
        }
        
    }
}
