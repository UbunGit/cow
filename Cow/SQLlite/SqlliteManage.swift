//
//  SqlliteManage.swift
//  Cow
//
//  Created by admin on 2021/8/12.
//

import Foundation
import Magicbox
import SQLite
import HandyJSON
public extension DispatchQueue{
    private static var _onceTracker = [String]()
    
     class func once(_ token : String, block:()->Void){
        objc_sync_enter(self)
        defer{
            objc_sync_exit(self)
        }
        if _onceTracker.contains(token) {
            return
        }
        _onceTracker.append(token)
        block()
    }
}
public let sm = SqlliteManage.share()

public class SqlliteManage{
    
    private static let onceToken = NSUUID().uuidString
    private static var _share : SqlliteManage? = nil
    
    public static func share()->SqlliteManage{
        DispatchQueue.once(onceToken) {
            _share = SqlliteManage()
        }
        return _share!
    }
  
    var sqlpath:String = "\(KDocumnetPath)/sqlite"
    
    public func sqlitePath() -> String{
        let sqlitePath = sqlpath
        let manager = FileManager.default
   
     
        let exist = manager.fileExists(atPath: sqlitePath)
        if !exist {
            try! manager.createDirectory(at: URL(fileURLWithPath: sqlitePath), withIntermediateDirectories: true,
                                         attributes: nil)
        }
       
        return  sqlitePath+"/sqlite.db"
    }
    
    public var db:Connection?{
        return try? Connection.init(sqlitePath())
    }
}

extension SqlliteManage{
 
    /**
     判断表是否存在
     */
    public func istable(tablename:String) throws -> Bool {
        let sql = """
            select count(*) as 'count' from sqlite_master where type ='table' and name = '\(tablename)'
            """
        guard let smb = try db?.scalar(sql)  else {
            throw(BaseError(code: -1, msg: "prepare nil"))
        }
        guard let result = smb as? Int64 else {
            throw(BaseError(code: -1, msg: "smb is not Int64"))
        }
        return (result == 1)
    }
    

    
    /**
     批量插入数据
     */
    public func mutableinster(table:String, column:[String],datas:[[String:Any]]) throws  {
        
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
                guard let str = item[$0] as? String else{
                    return "''"
                }
                return "'\(str)'"
                
            }.joined(separator: ",")
            return "(\(tvar))"
        }.joined(separator: ",")
        sql.append(val)
       debugPrint(sql)
       _ = try db?.execute(sql)
    }
    
 
}


// StockBasic
public extension SqlliteManage{
    
    func create_stockbasic() throws -> Bool{
        let sql = """
            CREATE TABLE IF NOT EXISTS "stockbasic" (
                "code"    TEXT NOT NULL,
                "name"    TEXT NOT NULL,
                "area"    TEXT NOT NULL,
                "industry"    TEXT NOT NULL,
                "market"    TEXT NOT NULL,
                "changeTime"    TEXT NOT NULL,
                PRIMARY KEY("code","name")
            );
            """
        try db?.execute(sql)
        return true
    }
    
}

// Follow
public extension SqlliteManage{
    func create_follow() throws{
        let sql = """
        CREATE TABLE IF NOT EXISTS "follow"(
        "id" INTEGER PRIMARY KEY AUTOINCREMENT,
        "type" INTEGER,
        "pid" INTEGER)
     """
        print(sql)
        try db?.execute(sql)
    }
    
    func inster_follow(type:Int, pid:String) throws{
        if try istable(tablename: "follow") == false {
            try create_follow()
        }
        let sql = """
     INSERT INTO "follow" (type,pid) SELECT '\(type)', '\(pid)'
     WHERE NOT EXISTS ( SELECT * FROM 'follow'
                        WHERE type = '\(type)'
                        AND pid = '\(pid)');
     """
        print(sql)
        try db?.execute(sql)
    }
    
    func delete_follow(id:Int) throws {
        let sql = """
         delete FROM  "follow"
         where id = '\(id)'
         """
        print(sql)
        try db?.execute(sql)
        }

}

// StockDaily
public extension SqlliteManage{
    func create_stockdaily() throws{
        let sql = """
        CREATE TABLE IF NOT EXISTS "stockdaily" -- 股票日数据
     (
        "date" TEXT, -- 时间
        "code" TEXT, -- 股票代码
        "open" NUMERIC, -- 开盘价
        "close" NUMERIC, -- 收盘价
        "high" NUMERIC, -- 最高价
        "low" NUMERIC, -- 最低价
        "vol" NUMERIC, -- 交易量
        "amount" NUMERIC, -- 交易价
        PRIMARY KEY("code","date")
     )
     """
        print(sql)
        try db?.execute(sql)
    }
    
    func delete_stockdaily(code:String) throws {
        let sql = """
         delete FROM  "stockdaily"
         where code = '\(code)'
         """
        print(sql)
        try db?.execute(sql)
    }
}

extension SqlliteManage{
    // 检查表是否创建完成
    func checkupTable() throws -> [Task] {
        var tasks:[Task] = []
        if try istable(tablename: "stockbasic") == false {
            tasks.append(Task.init(name: "创建StockBasic表", handle: {group in
                let _ =  try sm.create_stockbasic()
                group.leave()
            }))
        }
        if try istable(tablename: "follow") == false {
            tasks.append(Task.init(name: "创建follow表", handle: {group in
                let _ =  try sm.create_stockbasic()
                group.leave()
            }))
        }
        if try istable(tablename: "stockdaily") == false {
            tasks.append(Task.init(name: "创建stockdaily表", handle: {group in
                let _ =  try sm.create_stockdaily()
                group.leave()
            }))
        }
        
        return tasks
    }
    

}


extension Statement{

    
    public func to_moden<T>(_ type: T.Type)->[T] where T : HandyJSON{
        
         map { row-> T in
            
            var item:Dictionary = [String:Any]()
            for (index, name) in self.columnNames.enumerated() {
                item[name] = row[index]!
            }
            return T.deserialize(from: item)!
        }
        
    }
    public func to_dict()->[[String:Any]]{
        
         map { row-> [String:Any] in
            
            var item:Dictionary = [String:Any]()
            for (index, name) in self.columnNames.enumerated() {
                
                item[name] = row[index] ?? "?"
            }
            return item
        }
        
    }

}


