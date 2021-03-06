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
        log(sql)
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
        log(sql)
        try db?.execute(sql)
    }
    
    func delete_follow(id:Int) throws {
        let sql = """
         delete FROM  "follow"
         where id = '\(id)'
         """
        log(sql)
        try db?.execute(sql)
        }

}



extension Statement{

    
    public func to_moden<T>(_ type: T.Type)->[T] where T : HandyJSON{
        
         map { row-> T in
            
            var item:Dictionary = [String:Any]()
            for (index, name) in self.columnNames.enumerated() {
                item[name] = row[index].string()
            }
            return T.deserialize(from: item)!
        }
        
    }
    public func to_dict()->[[String:Any]]{
        var datas:[[String:Any]] = []
        forEach { row in
            var item:Dictionary = [String:Any]()
            for (index, name) in self.columnNames.enumerated() {
                if let value = row[index]{
                    item[name] = value
                }
            }
            if item.isEmpty == false{
                datas.append(item)
            }
            
        }
        return datas
      
        
    }

}

public extension Array where Element == [String:Any]  {
    func to_model<T>() -> [T]  where T:HandyJSON{
        map { T.deserialize(from: $0)! }
    }
}

extension SqlliteManage{
	func setup(){
        
        if isExistsTable("rel_transaction") == false{
            let _ = createTable("rel_transaction")
        }
		if isExistsTable("stock_price") == false{
			let _ = createTable("stock_price")
		}
		if isExistsTable("stock_basic") == false{
			let _ = createTable("stock_basic")
		}
	}
}




