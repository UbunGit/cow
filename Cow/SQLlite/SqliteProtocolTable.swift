//
//  SqliteProtocolTable.swift
//  Cow
//
//  Created by admin on 2021/8/9.
//

import Foundation
import SQLite


extension SqliteProtocol{
    
    func createTable(tableName:String, block: (TableBuilder) -> Void) -> Table? {
        do{
            let table = Table.init(tableName)
            try db?.run(table.create(temporary: false, ifNotExists: true, withoutRowid: false, block: { (builder) in
                block(builder)
            }))
            return table
        }catch(let error){
            debugPrint(error.localizedDescription)
            return nil
        }
    }
    
    @discardableResult func deleteTable(tableName:String) -> Bool {
        let exeStr = "drop table if exists \(tableName) "
        do {
            try db?.execute(exeStr)
            return true
        }catch(let error){
            debugPrint(error.localizedDescription)
            return  false
        }
    }
    
    @discardableResult func updateTable(oldName:String,newName:String) -> Bool {
        let exeStr = "alter table \(oldName) rename to \(newName) "
        do {
            try db?.execute(exeStr)
            return true
        }catch(let error){
            debugPrint(error.localizedDescription)
            return  false
        }
    }
    
    @discardableResult func addColumn(tableName:String,columnName:String,columnType:String) -> Bool {
          let exeStr = "alter table \(tableName) add \(columnName) \(columnType) "
          do {
              try db?.execute(exeStr)
              return true
          }catch(let error){
              debugPrint(error.localizedDescription)
              return  false
          }
      }
    
    func checkColumnExist(tableName:String,columnName:String) -> Bool {
          return  allColumns(tableName: tableName).filter { (model) -> Bool in
              return model.name == columnName
          }.count != 0
      }
    
    func allColumns(tableName:String) -> [TableColumn] {
        let exeStr = "PRAGMA table_info([\(tableName)]) "
        do {
            let stmt = try db?.prepare(exeStr)
            guard let result = stmt else {
                return []
            }
            var columns:[TableColumn] = []
            for case let row in result {
                guard row.count == 6 else {
                    continue
                }
                let column = TableColumn.init(cid: row[0] as? Int64, name: row[1] as? String, type: row[2] as? String, notnul: row[3] as? Int64 ??  0, defaultValue: row[4], primaryKey: row[5]  as? Int64 ??  0)
                columns.append(column)
                print(row)
            }
            return  columns
        }catch(let error){
            debugPrint(error.localizedDescription)
            return  []
        }
    }

}
