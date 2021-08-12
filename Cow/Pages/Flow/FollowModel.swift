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

public struct FollowModel:HandyJSON {
    
    var id:Int = 0
    public var code:String = ""
    public var name:String = ""
    public init() {
        
    }
}

extension FollowModel{

    func fitter(type:Int) throws -> [FollowModel] {
        do {
            let sql = """
                SELECT t1.id, t2.code, t2.name
                FROM  follow t1
                LEFT JOIN stockbasic t2 ON t1.pid=t2.code
                WHERE t1.type = 1
                """
            
            guard let stmt = try sm.db?.prepare(sql) else {
                throw(BaseError(code: -2, msg: ""))
            }
            let result = stmt.map { row->Self in
                
                var item:Dictionary = [String:Any]()
                for (index, name) in stmt.columnNames.enumerated() {
                    item[name] = row[index]!
                }
                return Self.deserialize(from: item)!
            }
            return result
        } catch let error {
            debugPrint(error.localizedDescription)
            return []
        }
        
    }
    
    func unfollow() throws {
        try sm.delete_follow(id: id)
    }
   
}
