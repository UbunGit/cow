//
//  SqliteDelete.swift
//  Cow
//
//  Created by admin on 2021/9/28.
//

import Foundation
import Magicbox
import SQLite

public extension SqlliteManage{
    func sql_delete(table:String,value:Any,key:String="id") -> String{
        let sql = """
         delete FROM  "\(table)"
         where \(key) = '\(value)'
        """
        return sql
    }
}
