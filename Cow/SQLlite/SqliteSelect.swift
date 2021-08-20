//
//  SqliteSelect.swift
//  Cow
//
//  Created by admin on 2021/8/17.
//

import Foundation
import HandyJSON
import Magicbox

extension SqlliteManage{
    
    func info(table:String)throws -> [[String:Any]]{
        let sql = """
            PRAGMA table_info(\(table));
            """
        guard let datas = try db?.prepare(sql).to_dict() else {
            return []
        }
        return datas
    }
    
    func count(table:String, fitter:String? = nil)throws -> Int {
        var sql = """
            select count(*) as 'count' from '\(table)'
            """
        if fitter != nil{
            sql.append(fitter!)
        }
        print("sql:"+sql)
        guard let smb = try db?.scalar(sql)  else {
            throw(BaseError(code: -1, msg: "prepare nil"))
        }
        guard let result = smb as? Int64 else {
            throw(BaseError(code: -1, msg: "smb is not Int64"))
        }
        return Int(result)
    }
    
    func last(table:String,
              orderby:[String] = [],
              isasc:Bool = false)throws -> [String:Any]? {
        
        var sql = """
            SELECT * FROM  \(table)
            """
        if orderby.count>0 {
            sql.append("""
            ORDER BY \(orderby.joined(separator: ",")) \(isasc ? "ASC" : "" )
            """)
            sql.append("""
            LIMIT 1 OFFSET 0
            """)
        }
        guard let datas = try db?.prepare(sql).to_dict() else {
            return [:]
        }
        return datas.last
    }
    
    func select(table:String,
                fitter:String = "",
                orderby:[String] = [],
                limmit:NSRange? = nil,
                isasc:Bool = true
                ) throws -> [[String:Any]] {
       
        var sql = """
            
            SELECT * FROM  \(table)
            """
        if fitter.count>0 {
            sql.append("""
           
              WHERE \(fitter)
           """)
        }
        if orderby.count>0 {
            sql.append("""
            
            ORDER BY \(orderby.joined(separator: ",")) \(isasc ? "ASC" : "DESC" )
            """)
        }
        if limmit != nil{
            sql.append("""
            
            LIMIT \(limmit!.length) OFFSET \(limmit!.location)
            """)
        }
        print(sql)
        guard let datas = try db?.prepare(sql).to_dict() else {
            return []
        }
        return datas
    }
}
