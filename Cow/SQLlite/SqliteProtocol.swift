//
//  SqliteProtocol.swift
//  Cow
//
//  Created by admin on 2021/8/9.
//

import Foundation
import SQLite
import Magicbox

struct TableColumn {
    
    var cid:Int64?
    var name:String?
    var type:String?
    var notnul:Int64?
    var defaultValue:Any?
    var primaryKey:Int64?
}


public protocol SqliteProtocol:Codable{

}
extension SqliteProtocol{
 
    public var db:Connection?{
        return try? Connection.init("\(KDocumnetPath)/sqlite")
    }
    
    var table:Table?{
        let id = Expression<Int64>.init("uId")
        let _table = self.createTable(tableName: "\(type(of: self))".lowercased(), block: { builder in
            builder.column(id, primaryKey: .autoincrement)
        })
        return _table
    }
}
