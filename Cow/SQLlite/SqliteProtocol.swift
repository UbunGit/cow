//
//  SqliteProtocol.swift
//  Cow
//
//  Created by admin on 2021/8/9.
//

import Foundation
import SQLite
import Magicbox
import HandyJSON

struct TableColumn {
    
    var cid:Int64?
    var name:String?
    var type:String?
    var notnul:Int64?
    var defaultValue:Any?
    var primaryKey:Int64?
}





public protocol SqliteProtocol:Codable,HandyJSON{
    var table:Table?{get}
    init(row: Row)
    
}
extension SqliteProtocol{
    public static func sqlitePath() -> String{
        let sqlitePath = UserDefaults.standard.string(forKey: "dbfile") ?? "\(KDocumnetPath)/sqlite"
        let manager = FileManager.default
   
     
        let exist = manager.fileExists(atPath: sqlitePath)
        if !exist {
            try! manager.createDirectory(at: URL(fileURLWithPath: sqlitePath), withIntermediateDirectories: true,
                                         attributes: nil)
        }
       
        return  sqlitePath+"/sqlite.db"
    }
    
    static var db:Connection?{
        return try? Connection.init(Self.sqlitePath())
    }
    public var db:Connection?{
        return Self.db
    }
    static var tableName:String{
        return "\(Self.self)".lowercased()
    }
    var tableName:String{
        return Self.tableName
    }
    
    var table:Table?{
        let id = Expression<Int64>.init("uId")
        let _table = self.createTable(tableName: tableName, block: { builder in
            builder.column(id, primaryKey: .autoincrement)
        })
        return _table
    }
}
